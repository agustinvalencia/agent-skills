# ML Review Patterns

Patterns and anti-patterns for reviewing ML code. Focused on the stack in active use: PyTorch, Lightning, Ray, MLflow, KAN, loguru, PyYAML, and Typer.

Each section lists flags worth raising in a review. Severity markers:
- **[critical]** — likely to cause silent wrong results or crashes in production
- **[warn]** — probably fine but deserves a comment or question
- **[style]** — not wrong, but inconsistent or harder to maintain than it needs to be

---

## General ML Anti-Patterns

**Data integrity**
- **[critical]** Leakage: preprocessing fitted on the full dataset before the train/test split (scaler, imputer, encoder, vocab). The split must come first.
- **[critical]** Leakage: target variable or a proxy for it included as a feature.
- **[critical]** Shuffling time-series data before splitting — future data ends up in the training set.
- **[warn]** Validation set used for early stopping *and* for hyperparameter selection — it is effectively a second training signal. A held-out test set should never touch the tuning loop.
- **[warn]** Same random seed used for both data split and model initialisation — makes it harder to tell which source of variance is driving results.

**Reproducibility**
- **[critical]** No seed set for `random`, `numpy`, `torch`, and (if relevant) `cuda`. Any benchmark or ablation without a fixed seed is unverifiable.
- **[warn]** Seed set but `torch.backends.cudnn.deterministic` not set to `True` when using CUDA — convolutions may still be non-deterministic.
- **[warn]** External dataset downloaded at runtime without pinning a version or checksum. Results may silently change if upstream data changes.
- **[warn]** Experiment results that depend on wall-clock time or process ID for any decision.

**Metrics**
- **[critical]** Accuracy reported on a class-imbalanced dataset without mention of the imbalance ratio or alternative metrics (F1, AUC, precision/recall).
- **[critical]** Loss reported on the training set presented as validation performance.
- **[warn]** Metric computed incrementally across batches by averaging per-batch values — correct only if batches are the same size. Use torchmetrics or accumulate numerator/denominator separately.
- **[warn]** Only one metric reported. For any serious evaluation, report at least two complementary metrics.

**Training loop**
- **[critical]** `model.eval()` not called during validation/inference — dropout and batch norm behave differently in train mode.
- **[critical]** `torch.no_grad()` not used during validation — wastes memory building a computation graph that is never used.
- **[warn]** Gradient clipping absent on RNNs or transformers — exploding gradients can corrupt training silently (loss goes to NaN or inf without an obvious error).
- **[warn]** Learning rate scheduler stepped at the wrong frequency (e.g. every batch instead of every epoch, or vice versa).
- **[warn]** `optimizer.zero_grad()` called after `loss.backward()` instead of before — accumulated gradients from the previous step corrupt the update.

---

## PyTorch

- **[critical]** In-place operation on a tensor that requires grad and is needed for the backward pass (e.g. `x += y` where `x` is an intermediate activation). Use `x = x + y`.
- **[critical]** `.detach()` or `.cpu()` not called before converting a tensor to numpy — will fail or silently break the computation graph.
- **[critical]** Loss computed on logits when the criterion expects probabilities, or vice versa (e.g. passing raw logits to `BCELoss` instead of `BCEWithLogitsLoss`).
- **[warn]** `DataLoader` with `num_workers=0` in any training context — single-threaded data loading is almost always the bottleneck on modern hardware.
- **[warn]** `pin_memory=False` when using CUDA — non-pinned memory requires an extra copy on transfer to the GPU.
- **[warn]** Tensor shape assumptions not documented or asserted. A silent broadcast can produce wrong results with no error. `einops` or explicit `assert x.shape == (B, C, H, W)` help.
- **[warn]** `model.parameters()` passed directly to the optimiser when only a subset should be trained (e.g. fine-tuning). Check that frozen layers have `requires_grad=False` before the optimiser is constructed.
- **[warn]** Device hardcoded as `"cuda"` instead of `device = torch.device("cuda" if torch.cuda.is_available() else "cpu")`.
- **[style]** `torch.Tensor` used as a type hint instead of `torch.FloatTensor` or an annotated shape — fine, but the latter is more informative in research code.

---

## PyTorch Lightning

- **[critical]** Custom training logic in `training_step` that manually calls `optimizer.zero_grad()`, `loss.backward()`, or `optimizer.step()` — Lightning handles these. Doing it manually double-applies updates or skips them depending on order.
- **[critical]** `self.log()` called with `on_step=True, on_epoch=True` for a metric that is only meaningful at epoch level (e.g. validation accuracy) — produces misleading step-level logs.
- **[warn]** `validation_step` return value used for anything other than logging — Lightning does not guarantee when or how it is aggregated. Use `validation_epoch_end` (or `on_validation_epoch_end` in newer versions) for aggregation.
- **[warn]** `Trainer(accelerator="gpu")` without `devices` specified — defaults to a single GPU, may not match the intended configuration.
- **[warn]** `LightningModule` that stores the full dataset as an attribute (`self.dataset = ...`) — the entire dataset gets serialised with the checkpoint. Use a `LightningDataModule` instead.
- **[warn]** `self.save_hyperparameters()` not called in `__init__` — hyperparameters won't be saved in the checkpoint, making it harder to reconstruct the model later.
- **[warn]** Callbacks with side effects (file writes, external calls) that are not guarded by `trainer.is_global_zero` in a multi-GPU context — every process will execute them independently.
- **[style]** Business logic mixed into the `LightningModule` (data loading, loss computation, metric logic all in one class). Prefer delegating to separate classes that the module calls.

---

## Ray (Distributed Training)

- **[critical]** Mutable shared state accessed from multiple actors without synchronisation (e.g. a plain Python dict passed by reference). Use a `ray.remote` actor with explicit method calls to serialise access.
- **[critical]** Large objects (datasets, model weights) passed as arguments to remote functions instead of via the object store (`ray.put`). This serialises and deserialises the object for every call, killing throughput.
- **[warn]** `ray.get()` called inside a loop — blocks on each call sequentially. Collect the futures first, then call `ray.get(futures)` once.
- **[warn]** No resource specification on `@ray.remote` tasks or actors (`num_cpus`, `num_gpus`). Ray defaults to 1 CPU per task; a GPU-heavy task with no `num_gpus=1` will not be scheduled on a GPU.
- **[warn]** `ray.init()` called without specifying `num_cpus` or `num_gpus` in environments where auto-detection is unreliable (containers, SLURM jobs).
- **[warn]** Actors that hold open file handles or database connections without a `__del__` or explicit shutdown method — leaked resources when the actor is killed.
- **[warn]** `ray.tune` trial configs that include non-serialisable objects (lambdas, open files). Tune serialises configs to checkpoint and restore trials.
- **[style]** Missing `runtime_env` specification when the code is expected to run on a remote cluster — worker nodes may have a different Python environment.

---

## MLflow

- **[critical]** Hyperparameters logged manually as params after the fact, or not logged at all. If you can't reconstruct the run from the logged params, the experiment is not reproducible.
- **[critical]** `mlflow.end_run()` not called (or no context manager used) when runs are created inside a loop — nested or dangling runs corrupt the experiment hierarchy.
- **[warn]** Model logged with `mlflow.pytorch.log_model` but the input signature not recorded (`mlflow.models.infer_signature`). Makes it harder to serve or validate the model later.
- **[warn]** Artifacts (plots, config files, preprocessors) not logged alongside the model. A model checkpoint without its preprocessing pipeline is not deployable.
- **[warn]** Same `run_name` reused across experiments — makes filtering and comparison unreliable. Use tags for grouping, not the run name.
- **[warn]** Metrics logged only at the end of training rather than per epoch — you lose the training curve and can't detect divergence.
- **[warn]** `MLFLOW_TRACKING_URI` not set explicitly — defaults to `./mlruns`, which means runs end up wherever the script is called from.
- **[style]** Custom tracking code duplicating what `mlflow.autolog()` already does for the framework in use (PyTorch Lightning, sklearn, etc.).

---

## Kolmogorov-Arnold Networks (KAN)

KANs replace fixed activation functions with learnable univariate functions on edges, typically parameterised as B-splines. The review concerns are different from standard MLPs.

**Architecture choices**
- **[critical]** Grid size (number of spline knots) set much larger than the training set. Overfitting risk is severe — each edge has `grid_size` parameters, and the total grows fast with width and depth.
- **[critical]** Spline order (`k`) set to 1 (piecewise linear) when the target function is known to be smooth. Linear splines have discontinuous derivatives, which breaks interpretability claims and degrades extrapolation.
- **[warn]** Network width set to match an MLP baseline without accounting for the fact that KANs have far more parameters per node than MLPs. A fairer comparison controls for total parameter count, not width.
- **[warn]** No grid extension (`model.refine(new_grid_size)`) used after initial training. KANs benefit from starting with a coarse grid and refining — training directly on a fine grid is less stable.
- **[warn]** Depth greater than 3–4 without justification. Deep KANs are harder to interpret and the spline composition becomes as opaque as an MLP. The interpretability argument for KANs weakens with depth.

**Interpretability**
- **[warn]** Interpretability claimed in the paper or comments without any symbolic regression or pruning step actually performed. A trained KAN is not automatically interpretable — it requires post-hoc analysis (`model.plot()`, pruning, symbolic fitting).
- **[warn]** Pruning threshold chosen arbitrarily. Document how the threshold was selected and what the pruned network's performance loss is.
- **[warn]** Symbolic formulas extracted without checking them on held-out data. Extracted formulas can overfit the training distribution even after regularisation.

**Training stability**
- **[warn]** Standard Adam learning rate (1e-3) used without adjustment. KANs are sensitive to learning rate — too high causes spline coefficient instability. Typical stable range is 1e-3 to 1e-4 with a scheduler.
- **[warn]** Entropy regularisation weight (`entropy_reg`) set to zero. Without regularisation, splines become spiky and non-interpretable even if the loss is low.
- **[warn]** Batch size very small relative to grid size — each batch covers only a fraction of the input range, leading to uneven spline fitting across the domain.
- **[style]** Using `kan.KAN` from the reference implementation in production without pinning the exact commit — the API has changed significantly across versions.

---

## loguru

- **[critical]** `logger.add()` called multiple times in library code without removing the default sink first — every import adds a new handler, producing duplicate log lines.
- **[critical]** Sensitive data (credentials, PII, patient data) passed directly into log messages. Log outputs are often stored long-term and may be scraped.
- **[warn]** Log level hardcoded as `"DEBUG"` in code that will run in production — verbose debug output from training loops can produce gigabytes of logs.
- **[warn]** `logger.add(sink, enqueue=False)` in a multi-process context (e.g. Ray workers, Lightning DDP). Non-enqueued file sinks from multiple processes will interleave or corrupt log files. Use `enqueue=True` or write to separate per-process files.
- **[warn]** Exception logging done with `logger.error(str(e))` instead of `logger.exception(e)` or `logger.opt(exception=True).error(...)` — the traceback is lost.
- **[warn]** No log rotation configured (`rotation`, `retention`) on long-running training jobs — log files can grow to fill the disk.
- **[style]** `print()` statements mixed with `logger` calls — pick one. In ML pipelines loguru is usually already imported; stray prints suggest incomplete migration or rushed debugging code left in.

---

## PyYAML

- **[critical]** `yaml.load(stream)` used without the `Loader` argument — defaults to `FullLoader` in newer PyYAML but raises a warning, and in older versions defaults to the unsafe loader which allows arbitrary Python object deserialisation. Always use `yaml.safe_load()` for config files, or `yaml.load(stream, Loader=yaml.SafeLoader)` explicitly.
- **[critical]** Config file loaded from a user-controlled or network path without validation. A malicious YAML file with `!!python/object` tags can execute arbitrary code if the unsafe loader is used.
- **[warn]** Floats written in YAML as bare values like `1e-3` — PyYAML parses these correctly, but some other parsers (e.g. strictyaml) do not. Prefer `0.001` for portability.
- **[warn]** Boolean-looking strings (`yes`, `no`, `on`, `off`, `true`, `false`) used as dictionary keys or values — PyYAML silently converts them to Python booleans. Quote them if you mean strings.
- **[warn]** Config written back with `yaml.dump()` without `default_flow_style=False` — produces compact single-line output that is hard to diff in git.
- **[warn]** No schema validation after loading. `yaml.safe_load` gives you an untyped dict. Missing keys or wrong types will fail late and with unhelpful errors. Validate with Pydantic or a dataclass immediately after loading.
- **[style]** Deep nested config structure with no comments. YAML configs for ML experiments tend to accumulate fields — undocumented keys become archaeology after six months.

---

## Typer

- **[warn]** `typer.run(main)` used instead of `app = typer.Typer(); app.command()` for a script that is likely to grow beyond a single command. Refactoring later is annoying.
- **[warn]** Path arguments typed as `str` instead of `pathlib.Path` (or `typer.Argument(..., exists=True)`) — Typer will not validate existence, and the rest of the code has to do it manually.
- **[warn]** No `--version` option on a CLI that is installed as a package entry point. Standard expectation for any distributed tool.
- **[warn]** Default values for training hyperparameters baked into Typer argument definitions rather than into a config file loaded by the CLI. Makes it easy to run experiments with different defaults accidentally.
- **[warn]** `typer.echo()` used for structured output that should go through the logger. Mixing typer output and loguru output makes log capture unreliable in pipeline contexts.
- **[style]** Long `help=` strings duplicating what the argument name already makes obvious. Be terse; save long explanations for `--help` at the command level, not per-argument.
- **[style]** No `callback=None` on the main app when subcommands are defined — Typer shows a confusing error if the user calls the root command with no subcommand.

---

## Cross-Cutting: Config + Experiment Management

These apply when PyYAML, Typer, MLflow, and Lightning are all in play together — which is the common pattern for a well-structured training pipeline.

- **[critical]** Config loaded from YAML but some hyperparameters also accepted as CLI args with different defaults — two sources of truth that can silently diverge. One should override the other, and the final resolved config should be what gets logged to MLflow.
- **[warn]** The config dict logged to MLflow is the raw loaded YAML, not the final resolved config after CLI overrides are applied.
- **[warn]** `LightningModule` takes hyperparameters as individual `__init__` args rather than a single config object. Fine for simple cases, becomes unmaintainable as the config grows.
- **[warn]** Experiment name in MLflow derived from the config filename rather than a meaningful, human-chosen name — all runs from a refactored config end up in the wrong experiment.
- **[style]** No separation between runtime config (paths, device, num_workers) and experiment config (hyperparameters). These should be logged differently — runtime config is infrastructure, experiment config determines reproducibility.

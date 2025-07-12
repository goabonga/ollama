# ollama

📦 Debian package builder for [Ollama](https://ollama.com), supporting multiple architectures and variants:

- `amd64`
- `arm64`

The packages include:
- the official `ollama` binary
- a systemd service (`ollama.service`)

## ✅ Features

- Generates `.deb` packages ready to install via `dpkg` or `apt`
- Installs `ollama` to `/usr/bin/ollama`
- Installs and enables the `ollama.service` on boot
- Creates a dedicated `ollama` user
- GitHub Actions workflow for CI builds and artifact publishing

## 🛠 Usage

You can build packages manually or use the GitHub workflow.

### Manual build

```bash
./scripts/build.sh <version> <arch> <output-dir>
```

Example:

```bash
./scripts/build.sh 1.0.0 amd64 dist/
./scripts/build.sh 1.0.0 arm64 dist/
```

This will generate `.deb` files in the `dist/` directory.

### GitHub Actions

This project automatically builds `.deb` packages on every push of a Git tag starting with `v`.

To trigger a build:

```bash
git tag v1.0.0
git push origin v1.0.0
```

This will:
- Run the GitHub Actions workflow
- Build all `.deb` packages (amd64, arm64)
- Upload the resulting `.deb` files as downloadable artifacts


## 📦 Install the package

```bash
sudo dpkg -i ollama_<version>_<arch>.deb
sudo systemctl enable --now ollama
```

## 🔐 Security notes

The package creates a system user `ollama` to isolate the daemon. It does not run as root.  
Ensure the binary comes from a trusted source (`ollama.com`) or verify the tarball manually.

## 📁 Layout

```
scripts/                → build script
debian/DEBIAN/          → control files (control, postinst)
debian/usr/lib/...      → tmpfiles.d configuration
debian/lib/systemd/...  → ollama systemd unit
.github/workflows/      → GitHub CI workflow
```

## 🧪 Tested on

- Ubuntu 22.04 LTS
- GitHub-hosted runners (`ubuntu-latest`)

---

© 2025 [GOABONGA](https://goabonga.com) - Not affiliated with Ollama.
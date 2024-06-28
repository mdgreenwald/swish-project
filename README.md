# swish-project

Swish demonstration project to show tooling.

## Requirements

* asdf
* ctlptl
* just
* kind
* kubectl
* make
* poetry
* python
* tilt

## Getting Started

1. Run the bootstrap script at `scripts/bootstrap.sh` by invoking `make bootstrap`.

   ⚠️ This script will install `asdf` and `just`  and will modify `.bashrc` or `.zshrc` depending. Please review the script before execution. ⚠️

2. Run `just bootstrap` to finish installing all dependencies.

3. Run `just up` to start the development environment. The first time might take a few minutes.
   1. You should see something like: Tilt started on http://localhost:10350/ where you can view Tilt.
   2. Visit http://localhost:8080/ and "Hello world" should be visible in your browser window.

4. Code changes will be live shortly after making them. For example, try changing "Hello world" on L8 in `src/main.py` to something else like "Kubernetes rules!"

## Documentation

Detailed project documentation at: `docs/README.md`

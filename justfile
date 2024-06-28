bootstrap:
    asdf plugin add ctlptl https://github.com/ezcater/asdf-ctlptl.git
    asdf plugin add kind https://github.com/johnlayton/asdf-kind.git
    asdf plugin add kubectl https://github.com/asdf-community/asdf-kubectl.git
    asdf plugin add poetry https://github.com/asdf-community/asdf-poetry.git
    asdf plugin add python https://github.com/danhper/asdf-python.git
    asdf plugin add tilt https://github.com/eaceaser/asdf-tilt.git
    asdf install

up: start-k8s
    tilt up

down:
    kubectl config set-context --current --namespace=swish
    tilt down --delete-namespaces
    just stop-k8s

start-k8s:
    ctlptl create cluster kind --registry=ctlptl-registry || true
    kubectl config set-context --current --namespace=swish

stop-k8s:
    ctlptl delete --ignore-not-found cluster kind

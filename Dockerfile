ARG TFLINT_VERSION
ARG TERRAFORM_VERSION
ARG GOLANG_VERSION
FROM hashicorp/terraform:${TERRAFORM_VERSION} AS terraform
FROM wata727/tflint:${TFLINT_VERSION} AS tflint
FROM golang:${GOLANG_VERSION}-alpine3.10 AS alpine

COPY --from=terraform /bin/terraform /bin/terraform
COPY --from=tflint /usr/local/bin/tflint /bin/tflint

RUN apk add --no-cache \
    # Because terratest uses cgo
    alpine-sdk~=1.0 \
    # Ensure compatibility with CircleCI
    bash~=5.0 \
    grep~=3.3 \
    groff~=1.22 \
    less~=551 \
    python3~=3.7 \
    # In case there are SSH module sources
    openssh-client~=8.1 \
    zip~=3.0 && \
  pip3 install --no-cache --upgrade \
    pip==19.3.1 \
    poetry==0.12.17

ENTRYPOINT [ "/bin/sh", "-c" ]

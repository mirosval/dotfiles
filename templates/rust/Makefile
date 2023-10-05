RUST_VERSION = $(shell cat rust-toolchain.toml)

guard-%:
	@ if [ "${${*}}" = "" ]; then \
                echo "Environment variable $* not set"; \
                exit 1; \
        fi

print-%  : ; @echo $*=$($*)

.PHONY: dev
dev:
	cargo watch -c -x 'check' -x 'test' -x 'run'

outdated:
	cargo outdated -R

unused:
	cargo +nightly udeps

update:
	cargo update

clean:
	cargo clean

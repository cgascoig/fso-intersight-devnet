SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
# .DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifeq ($(origin .RECIPEPREFIX), undefined)
  $(error This Make does not support .RECIPEPREFIX. Please use GNU Make 4.0 or later)
endif
# .RECIPEPREFIX = >

GIT_COMMIT_SUFFIX := $(shell if [[ -n $$(git status --porcelain) ]]; then echo "-next"; else echo ""; fi)
GIT_COMMIT := $(shell git rev-parse HEAD)$(GIT_COMMIT_SUFFIX)
BUILD_DATETIME := $(shell date '+%F-%T')

GLOBAL_FILES := Makefile 
POD_TEMPLATE_FILES := $(shell find pod-template -type f)

NUM_PODS = 15
POD_LIST = $(shell for i in $$(seq -w 1 $(NUM_PODS)); do echo "pod$${i}"; done)

all::
.PHONY: all

define make-pod-target =
pods/$1/solution/manifest.json: $(GLOBAL_FILES) $(POD_TEMPLATE_FILES)
	rm -Rf "pods/$1"
	mkdir -p "pods/$1"
	for f in $$$$(cd pod-template; find . -type f); do d=$$$$(dirname $$$${f}); mkdir -p "pods/$1/$$$${d}"; sed -e 's/intersightdevnet/intersightdevnet$1/g' "pod-template/$$$${f}" > "pods/$1/$$$${f}"; done

all:: pods/$1/solution/manifest.json
endef

$(foreach element,$(POD_LIST),$(eval $(call make-pod-target,$(element))))

# solutions/pod01/manifest.json: $(GLOBAL_FILES) $(SOLUTION_TEMPLATE_FILES)
# > mkdir -p $(@D)
# > for f in $$(cd solution-template; find . -type f); do d=$$(dirname $${f}); mkdir -p "solutions/pod01/$${d}"; cp "solution-template/$${f}" "solutions/pod01/$${f}"; done
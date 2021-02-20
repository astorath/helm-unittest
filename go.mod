module github.com/astorath/helm3-unittest

go 1.15

require (
	github.com/bradleyjkemp/cupaloy/v2 v2.6.0
	github.com/fatih/color v1.7.0
	github.com/mitchellh/mapstructure v1.1.2
	github.com/pmezard/go-difflib v1.0.0
	github.com/spf13/cobra v1.1.3
	github.com/stretchr/testify v1.7.0
	gopkg.in/yaml.v2 v2.4.0
	helm.sh/helm/v3 v3.5.2
)

replace (
	github.com/docker/distribution => github.com/docker/distribution v0.0.0-20191216044856-a8371794149d
	github.com/docker/docker => github.com/moby/moby v17.12.0-ce-rc1.0.20200618181300-9dc6525e6118+incompatible
)

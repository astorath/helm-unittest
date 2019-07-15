package main // gitlab.3adigital.ru/gitlab-ci/helm-unittest
import (
	"gitlab.3adigital.ru/gitlab-ci/helm-unittest/unittest"
)

var version string

func main() {
	unittest.Execute(version)
}

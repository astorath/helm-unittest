package main // github.com/lrills/helm-unittest
import (
	"github.com/lrills/helm-unittest/unittest"
)

var version string

func main() {
	unittest.Execute(version)
}

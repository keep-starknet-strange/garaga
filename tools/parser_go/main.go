package main

import (
	"fmt"
	"github.com/consensys/gnark-crypto/ecc/bn254/fp"
	"github.com/urfave/cli"
	"log"
	"os"
	"strconv"
)

// E2 is a degree two finite field extension of fp.Element
type E2 struct {
	A0, A1 fp.Element
}

// Add adds two elements of E2
func (z *E2) Add(x, y *E2) *E2 {
	addE2(z, x, y)
	return z
}

func addE2(z, x, y *E2) {
	z.A0.Add(&x.A0, &y.A0)
	z.A1.Add(&x.A1, &y.A1)
}

var app = cli.NewApp()

func info() {
	app.Name = "Gnark parser CLI"
	app.Usage = "An example CLI for parsing hint input"
	app.Author = "Bacharif"
	app.Version = "1.0.0"
}

func main() {
	info()
	app.Action = func(c *cli.Context) error {
		var z, x, y E2
		ui64, _ := strconv.ParseUint(c.Args().Get(0), 10, 64)
		A0 := fp.NewElement(ui64)
		ui64, _ = strconv.ParseUint(c.Args().Get(1), 10, 64)
		A1 := fp.NewElement(ui64)
		ui64, _ = strconv.ParseUint(c.Args().Get(2), 10, 64)
		A2 := fp.NewElement(ui64)
		ui64, _ = strconv.ParseUint(c.Args().Get(3), 10, 64)
		A3 := fp.NewElement(ui64)

		x.A0 = A0
		x.A1 = A1

		y.A0 = A2
		y.A1 = A3

		z.Add(&x, &y)

		fmt.Println(z)
		return nil
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

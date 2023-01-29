package main

import (
	"fmt"
	"github.com/consensys/gnark-crypto/ecc/bn254/fp"
	"github.com/urfave/cli"
	"log"
	"math/big"
	"os"
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

// Sub two elements of E2
func (z *E2) Sub(x, y *E2) *E2 {
	subE2(z, x, y)
	return z
}

func subE2(z, x, y *E2) {
	z.A0.Sub(&x.A0, &y.A0)
	z.A1.Sub(&x.A1, &y.A1)
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
		var A0, A1, A2, A3 fp.Element
		n := new(big.Int)
		n, _ = n.SetString(c.Args().Get(1), 10)
		A0.SetBigInt(n)
		n, _ = n.SetString(c.Args().Get(2), 10)
		A1.SetBigInt(n)
		n, _ = n.SetString(c.Args().Get(3), 10)
		A2.SetBigInt(n)
		n, _ = n.SetString(c.Args().Get(3), 10)
		A3.SetBigInt(n)

		x.A0 = A0
		x.A1 = A1

		y.A0 = A2
		y.A1 = A3

		switch c.Args().Get(0) {
		case "add":
			z.Add(&x, &y)
		case "sub":
			z.Sub(&x, &y)
		}

		fmt.Println(z)
		return nil
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

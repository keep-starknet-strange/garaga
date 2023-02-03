package main

import (
	"fmt"
	"log"
	"math/big"
	"os"

	"github.com/bacharif/garaga/internal/fptower"
	"github.com/consensys/gnark-crypto/ecc/bn254/fp"
	"github.com/urfave/cli"
)

var app = cli.NewApp()

func info() {
	app.Name = "Gnark parser CLI"
	app.Usage = "An example CLI for parsing hint input"
	app.Author = "Bacharif"
	app.Version = "1.0.0"
}

func load_e2_from_args(c *cli.Context, pos int) fptower.E2 {
	var x fptower.E2
	var A0, A1 fp.Element
	n := new(big.Int)
	n, _ = n.SetString(c.Args().Get(pos+0), 10)
	A0.SetBigInt(n)
	n, _ = n.SetString(c.Args().Get(pos+1), 10)
	A1.SetBigInt(n)

	x.A0 = A0
	x.A1 = A1
	return x
}

func load_e6_from_args(c *cli.Context, pos int) fptower.E6 {
	var x fptower.E6
	var x0, x1, x2 fptower.E2
	x0 = load_e2_from_args(c, pos)
	x1 = load_e2_from_args(c, pos+2)
	x2 = load_e2_from_args(c, pos+4)

	x.B0 = x0
	x.B1 = x1
	x.B2 = x2

	return x
}

func load_e12_from_args(c *cli.Context, pos int) fptower.E12 {
	var x fptower.E12
	var x0, x1 fptower.E6
	x0 = load_e6_from_args(c, pos)
	x1 = load_e6_from_args(c, pos+6)

	x.C0 = x0
	x.C1 = x1

	return x
}

func main() {
	info()
	app.Action = func(c *cli.Context) error {

		switch c.Args().Get(0) {
		case "e2":
			var z, x, y fptower.E2
			x = load_e2_from_args(c, 2)
			y = load_e2_from_args(c, 2+2)

			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "div":
				z.Div(&x, &y)
			case "mul":
				z.Mul(&x, &y)
			}
			fmt.Println(z)
		case "e6":
			var z, x, y fptower.E6
			x = load_e6_from_args(c, 2)
			y = load_e6_from_args(c, 2+2*3)

			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "mul":
				z.Mul(&x, &y)
			}
			fmt.Println(z)
		case "e12":
			var z, x, y fptower.E12
			x = load_e12_from_args(c, 2)
			y = load_e12_from_args(c, 2+12)
			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "mul":
				z.Mul(&x, &y)
			}

			fmt.Println(z)

		}

		return nil
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

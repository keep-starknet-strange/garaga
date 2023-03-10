package main

import (
	"fmt"
	"log"
	"math/big"
	"os"
	"tools/parser_go/bn254"
	"tools/parser_go/bn254/fp"
	"tools/parser_go/bn254/fptower"

	"github.com/urfave/cli"
)

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

		switch c.Args().Get(0) {
		case "e2":
			var z, x, y fptower.E2
			var A0, A1, A2, A3 fp.Element
			n := new(big.Int)
			n, _ = n.SetString(c.Args().Get(2), 10)
			A0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(3), 10)
			A1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(4), 10)
			A2.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(5), 10)
			A3.SetBigInt(n)

			x.A0 = A0
			x.A1 = A1
			y.A0 = A2
			y.A1 = A3

			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "div":
				z.Div(&x, &y)
			case "mul":
				z.Mul(&x, &y)
			case "neg":
				z.Neg(&x)
			case "inv":
				z.Inverse(&x)
			case "conjugate":
				z.Conjugate(&x)
			case "mulbnr1p1":
				z.MulByNonResidue1Power1(&x)
			case "mulbnr1p2":
				z.MulByNonResidue1Power2(&x)
			case "mulbnr1p3":
				z.MulByNonResidue1Power3(&x)
			case "mulbnr1p4":
				z.MulByNonResidue1Power4(&x)
			case "mulbnr1p5":
				z.MulByNonResidue1Power5(&x)
			}

			z.A0.FromMont()
			z.A1.FromMont()
			fmt.Println(z)

		case "nG1nG2":
			var P1 bn254.G1Affine
			var P2 bn254.G2Affine

			n1 := new(big.Int)
			n2 := new(big.Int)

			n1.SetString(c.Args().Get(1), 10)
			n2.SetString(c.Args().Get(2), 10)
			_, _, genG1, genG2 := bn254.Generators()
			P1.ScalarMultiplication(&genG1, n1)
			P2.ScalarMultiplication(&genG2, n2)

			P1.X.FromMont()
			P1.Y.FromMont()
			P2.X.A0.FromMont()
			P2.X.A1.FromMont()
			P2.Y.A0.FromMont()
			P2.Y.A1.FromMont()

			fmt.Println(P1)
			fmt.Println(P2)
		case "e6":
			var z, x, y fptower.E6
			var A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11 fp.Element
			n := new(big.Int)
			n, _ = n.SetString(c.Args().Get(2), 10)
			A0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(3), 10)
			A1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(4), 10)
			A2.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(5), 10)
			A3.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(6), 10)
			A4.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(7), 10)
			A5.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(8), 10)
			A6.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(9), 10)
			A7.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(10), 10)
			A8.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(11), 10)
			A9.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(12), 10)
			A10.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(13), 10)
			A11.SetBigInt(n)

			x.B0.A0 = A0
			x.B0.A1 = A1
			x.B1.A0 = A2
			x.B1.A1 = A3
			x.B2.A0 = A4
			x.B2.A1 = A5

			y.B0.A0 = A6
			y.B0.A1 = A7
			y.B1.A0 = A8
			y.B1.A1 = A9
			y.B2.A0 = A10
			y.B2.A1 = A11

			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "double":
				z.Double(&x)
			case "mul":
				z.Mul(&x, &y)
			case "mul_by_non_residue":
				z.MulByNonResidue(&x)
			case "neg":
				z.Neg(&x)
			}
			z.B0.A0.FromMont()
			z.B0.A1.FromMont()
			z.B1.A0.FromMont()
			z.B1.A1.FromMont()
			z.B2.A0.FromMont()
			z.B2.A1.FromMont()

			fmt.Println(z)
		case "e12":
			var z, x, y fptower.E12
			var A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11 fp.Element
			var B0, B1, B2, B3, B4, B5, B6, B7, B8, B9, B10, B11 fp.Element
			n := new(big.Int)
			n, _ = n.SetString(c.Args().Get(2), 10)
			A0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(3), 10)
			A1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(4), 10)
			A2.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(5), 10)
			A3.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(6), 10)
			A4.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(7), 10)
			A5.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(8), 10)
			A6.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(9), 10)
			A7.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(10), 10)
			A8.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(11), 10)
			A9.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(12), 10)
			A10.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(13), 10)
			A11.SetBigInt(n)

			n, _ = n.SetString(c.Args().Get(14), 10)
			B0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(15), 10)
			B1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(16), 10)
			B2.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(17), 10)
			B3.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(18), 10)
			B4.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(19), 10)
			B5.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(20), 10)
			B6.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(21), 10)
			B7.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(22), 10)
			B8.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(23), 10)
			B9.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(24), 10)
			B10.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(25), 10)
			B11.SetBigInt(n)

			x.C0.B0.A0 = A0
			x.C0.B0.A1 = A1
			x.C0.B1.A0 = A2
			x.C0.B1.A1 = A3
			x.C0.B2.A0 = A4
			x.C0.B2.A1 = A5
			x.C1.B0.A0 = A6
			x.C1.B0.A1 = A7
			x.C1.B1.A0 = A8
			x.C1.B1.A1 = A9
			x.C1.B2.A0 = A10
			x.C1.B2.A1 = A11

			y.C0.B0.A0 = B0
			y.C0.B0.A1 = B1
			y.C0.B1.A0 = B2
			y.C0.B1.A1 = B3
			y.C0.B2.A0 = B4
			y.C0.B2.A1 = B5
			y.C1.B0.A0 = B6
			y.C1.B0.A1 = B7
			y.C1.B1.A0 = B8
			y.C1.B1.A1 = B9
			y.C1.B2.A0 = B10
			y.C1.B2.A1 = B11

			switch c.Args().Get(1) {
			case "add":
				z.Add(&x, &y)
			case "sub":
				z.Sub(&x, &y)
			case "mul":
				z.Mul(&x, &y)
			case "square":
				z.Square(&x)
			case "double":
				z.Double(&x)
			case "inv":
				z.Inverse(&x)

			case "conjugate":
				z.Conjugate(&x)
			case "cyclotomic_square":
				z.CyclotomicSquare(&x)
			case "expt":
				z.Expt(&x)
			case "frobenius_square":
				z.FrobeniusSquare(&x)
			case "frobenius_cube":
				z.FrobeniusCube(&x)
			case "frobenius":
				z.Frobenius(&x)

			}
			z.C0.B0.A0.FromMont()
			z.C0.B0.A1.FromMont()
			z.C0.B1.A0.FromMont()
			z.C0.B1.A1.FromMont()
			z.C0.B2.A0.FromMont()
			z.C0.B2.A1.FromMont()
			z.C1.B0.A0.FromMont()
			z.C1.B0.A1.FromMont()
			z.C1.B1.A0.FromMont()
			z.C1.B1.A1.FromMont()
			z.C1.B2.A0.FromMont()
			z.C1.B2.A1.FromMont()

			fmt.Println(z)

		case "pair":
			var X bn254.G1Affine
			var Y bn254.G2Affine
			var X0, X1 fp.Element
			var Y0, Y1, Y2, Y3 fp.Element
			var z fptower.E12
			n := new(big.Int)

			n, _ = n.SetString(c.Args().Get(2), 10)
			X0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(3), 10)
			X1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(4), 10)
			Y0.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(5), 10)
			Y1.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(6), 10)
			Y2.SetBigInt(n)
			n, _ = n.SetString(c.Args().Get(7), 10)
			Y3.SetBigInt(n)
			X.X = X0
			X.Y = X1
			Y.X.A0 = Y0
			Y.X.A1 = Y1
			Y.Y.A0 = Y2
			Y.Y.A1 = Y3
			g1_arr := []bn254.G1Affine{X}
			g2_arr := []bn254.G2Affine{Y}

			switch c.Args().Get(1) {
			case "pair":
				Z, _ := bn254.Pair(g1_arr, g2_arr)

				z.Set(&Z)

			case "miller_loop":
				Z, _ := bn254.MillerLoop(g1_arr, g2_arr)
				z.Set(&Z)
			}
			z.C0.B0.A0.FromMont()
			z.C0.B0.A1.FromMont()
			z.C0.B1.A0.FromMont()
			z.C0.B1.A1.FromMont()
			z.C0.B2.A0.FromMont()
			z.C0.B2.A1.FromMont()
			z.C1.B0.A0.FromMont()
			z.C1.B0.A1.FromMont()
			z.C1.B1.A0.FromMont()
			z.C1.B1.A1.FromMont()
			z.C1.B2.A0.FromMont()
			z.C1.B2.A1.FromMont()

			fmt.Println(z)

		case "n_pair":

			var z fptower.E12

			n := new(big.Int)
			n, _ = n.SetString(c.Args().Get(2), 10)

			g1_arr := make([]bn254.G1Affine, int(n.Int64()))
			g2_arr := make([]bn254.G2Affine, int(n.Int64()))

			for i := 0; i < int(n.Int64()); i++ {
				felt := new(big.Int)

				// var X bn254.G1Affine
				// var Y bn254.G2Affine
				var X0, X1 fp.Element
				var Y0, Y1, Y2, Y3 fp.Element

				felt, _ = felt.SetString(c.Args().Get(3+i), 10)
				X0.SetBigInt(felt)
				felt, _ = felt.SetString(c.Args().Get(4+i), 10)
				X1.SetBigInt(felt)
				felt, _ = felt.SetString(c.Args().Get(5+i), 10)
				Y0.SetBigInt(felt)
				felt, _ = felt.SetString(c.Args().Get(6+i), 10)
				Y1.SetBigInt(felt)
				felt, _ = felt.SetString(c.Args().Get(7+i), 10)
				Y2.SetBigInt(felt)
				felt, _ = felt.SetString(c.Args().Get(8+i), 10)
				Y3.SetBigInt(felt)

				X := &g1_arr[i]
				X.X = X0
				X.Y = X1

				Y := &g2_arr[i]
				Y.X.A0 = Y0
				Y.X.A1 = Y1
				Y.Y.A0 = Y2
				Y.Y.A1 = Y3
			}

			switch c.Args().Get(1) {
			case "pair":
				Z, _ := bn254.Pair(g1_arr, g2_arr)

				z.Set(&Z)

			case "miller_loop":
				Z, _ := bn254.MillerLoop(g1_arr, g2_arr)
				z.Set(&Z)
			}
			z.C0.B0.A0.FromMont()
			z.C0.B0.A1.FromMont()
			z.C0.B1.A0.FromMont()
			z.C0.B1.A1.FromMont()
			z.C0.B2.A0.FromMont()
			z.C0.B2.A1.FromMont()
			z.C1.B0.A0.FromMont()
			z.C1.B0.A1.FromMont()
			z.C1.B1.A0.FromMont()
			z.C1.B1.A1.FromMont()
			z.C1.B2.A0.FromMont()
			z.C1.B2.A1.FromMont()

			fmt.Println(z)
		}

		return nil
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}

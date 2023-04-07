# Gnark command-line for Cairo hint

## Build:

```
go build main.go
```

## Usage:

For e2:

```
./main e2 add 10 22 34 43
./main e2 sub 10 22 34 43
./main e2 div 10 22 34 43
./main e2 mul 10 22 34 43
```

For e6:

```
./main e6 add 1 2 3 4 5 6 6 5 4 3 2 1
./main e6 sub 1 2 3 4 5 6 6 5 4 3 2 1
./main e6 mul 1 2 3 4 5 6 6 5 4 3 2 1
```

For e12:

```
./main e12 add 1 2 3 4 5 6 7 8 9 10 11 12 12 11 10 9 8 7 6 5 4 3 2 1
./main e12 sub 1 2 3 4 5 6 7 8 9 10 11 12 12 11 10 9 8 7 6 5 4 3 2 1
./main e12 mul 1 2 3 4 5 6 7 8 9 10 11 12 12 11 10 9 8 7 6 5 4 3 2 1
```

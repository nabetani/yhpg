package main

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

func isGuru(b, i int32) bool {
	prev := (*int32)(nil)
	for {
		num := i % b
		i = (i - num) / b
		if prev != nil {
			if *prev != num && *prev != (num+1)%b {
				return false
			}
		}
		if i == 0 {
			return true
		}
		prev = &num
	}
}

func impl(b, x, y int32) int32 {
	c := int32(0)
	for i := x; i <= y; i++ {
		if isGuru(b, i) {
			c++
		}
	}
	return c
}

func solveSlow(src string) string {
	vals := strings.Split(src, ",")
	b, e0 := strconv.Atoi(vals[0])
	x, e1 := strconv.ParseInt(vals[1], b, 32)
	y, e2 := strconv.ParseInt(vals[2], b, 32)
	if e0 != nil || e1 != nil || e2 != nil {
		panic(fmt.Sprint(e0, e1, e2))
	}
	count := impl(int32(b), int32(x), int32(y))
	return fmt.Sprint(count)
}

func test() {
	type dataType struct {
		src, expected string
	}
	data := []dataType{
		dataType{src: "4,1313,3012", expected: "12"},

		dataType{src: "10,123,4567", expected: "65"},
		dataType{src: "7,123,4560", expected: "52"},
		dataType{src: "19,123,abcd", expected: "149"},
		dataType{src: "2,1010,10101010", expected: "161"},
		dataType{src: "3,1010,10101010", expected: "240"},
	}
	for _, t := range data {
		actual := solveSlow(t.src)
		fmt.Printf("solveSlow(%q)=%q, want %q\n", t.src, actual, t.expected)
		if actual != t.expected {
			panic(t.src)
		}
	}
}

func main() {
	test()
	for i := 4; ; i++ {
		start := time.Now()
		for _, b := range []int{2, 10, 36} {
			hi := uint32(1) << uint32(i)
			shi := strconv.FormatUint(uint64(hi), b)
			src := fmt.Sprintf("%d,1,%s", b, shi)
			actual := solveSlow(src)
			fmt.Println(src, actual)
		}
		tick := time.Now().Sub(start).Seconds()
		fmt.Printf("src = 2**%d -> tick = %.2f sec\n", i, tick)
		fmt.Println("------------------")
		if 60 < tick {
			break
		}
	}
}

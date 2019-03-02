package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"
	"strconv"
	"strings"
	"time"
)

func isGuru(b, i int32) bool {
	prev := int32(-1)
	for {
		num := i % b
		i = (i - num) / b
		if 0 <= prev {
			if prev != num && prev != (num+1)%b {
				return false
			}
		}
		if i == 0 {
			return true
		}
		prev = num
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

func bytesFromFile(fn string) []byte {
	f, err := os.Open(fn)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	b, err := ioutil.ReadAll(f)
	if err != nil {
		panic(err)
	}
	return b
}

type testDataType struct {
	Number   int    `json:"number"`
	Src      string `json:"src"`
	Expected string `json:"expected"`
}

type dataType struct {
	EventID  string         `json:"event_id"`
	EventURL string         `json:"event_url"`
	TestData []testDataType `json:"test_data"`
}

func runTest(list []testDataType) {
	for _, t := range list {
		start := time.Now()
		actual := solveSlow(t.Src)
		tick := time.Now().Sub(start).Seconds()
		result := func() string {
			if actual == t.Expected {
				return "ok"
			}
			return "***NG***"
		}()
		fmt.Printf("%2d:%s solve(%q)=%q, want %q ( %.3f sec )\n", t.Number, result, t.Src, actual, t.Expected, tick)
	}
}

func main() {
	data := dataType{}
	json.Unmarshal(bytesFromFile(os.Args[1]), &data)
	start := time.Now()
	runTest(data.TestData)
	tick := time.Now().Sub(start).Seconds()
	fmt.Printf("total : %.2f sec\n", tick)
}

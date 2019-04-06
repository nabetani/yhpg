package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

type rectType struct {
	x, y, r, b int
}

func (r *rectType) size() int {
	return (r.r - r.x) * (r.b - r.y)
}

func mustAtoi(s string) int {
	i, err := strconv.ParseInt(s, 36, 32)
	if err != nil {
		log.Fatalln(err)
	}
	return int(i)
}

func createRect(s string) rectType {
	return rectType{
		x: mustAtoi(s[0:1]),
		y: mustAtoi(s[1:2]),
		r: mustAtoi(s[2:3]),
		b: mustAtoi(s[3:4]),
	}
}

func solveImpl(rects []rectType) []rectType {
	return rects
}

func solve(src string) string {
	srects := strings.Split(src, "/")
	rects := []rectType{}
	for _, s := range srects {
		rects = append(rects, createRect(s))
	}
	sizes := []int{}
	for _, r := range solveImpl(rects) {
		sizes = append(sizes, r.size())
	}
	sort.Ints(sizes)
	ssizes := []string{}
	for _, size := range sizes {
		ssizes = append(ssizes, fmt.Sprintf("%d", size))
	}
	return strings.Join(ssizes, ",")
}

func main() {
	var data map[string]interface{}
	jsonBytes, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	json.Unmarshal(jsonBytes, &data)
	for _, item := range data["test_data"].([]interface{}) {
		i := item.(map[string]interface{})
		e := i["expected"].(string)
		s := i["src"].(string)
		a := solve(s)
		ok := e == a
		if ok {
			log.Println("ok", s, e)
		} else {
			log.Println("**NG**", s, a, e)
		}
	}
}

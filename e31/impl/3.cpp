// clang++ -O2 -std=c++17 -Wall -Xpreprocessor -fopenmp -lomp  3.cpp

#include <iomanip>
#include <iostream>
#include <numeric>
#include <regex>
#include <sstream>
#include <string>

int is_guru(int b, int i) {
  auto prev{-1};
  for (;;) {
    auto num = i % b;
    if (0 <= prev && prev != num && prev != (num + 1) % b) {
      return 0;
    }
    i = (i - num) / b;
    if (i == 0) {
      return 1;
    }
    prev = num;
  }
}

std::string solve(std::string const &src) {
  auto regex = std::regex(R"(^([^\,]+)\,([^\,]+)\,([^\,]+))");
  std::smatch m;
  std::regex_match(src, m, regex);
  auto b = std::stoi(m[1]);
  auto x = std::strtol(m[2].str().c_str(), nullptr, b);
  auto y = std::strtol(m[3].str().c_str(), nullptr, b);
  int count = 0;
#pragma omp parallel for reduction(+ : count)
  for (int i = x; i <= y; ++i) {
    count += is_guru(b, i);
  }
  return std::to_string(count);
}

void test(std::string const &src, std::string const &expected) {
  auto actual{solve(src)};
  auto okay{actual == expected};
  std::cout << (okay ? "ok" : "**NG**") << " " << src << " " << actual << " "
            << expected << std::endl;
}

int main() {
  /*0*/ test("4,1313,3012", "12");
  /*1*/ test("10,100,110", "0");
  /*2*/ test("36,zoo,zyz", "0");
  /*3*/ test("4,1300000,2222221", "0");
  /*4*/ test("2,1,1", "1");
  /*5*/ test("2,1000,1110", "7");
  /*6*/ test("4,21,132", "8");
  /*7*/ test("10,28,79", "10");
  /*8*/ test("36,q,1r", "12");
  /*9*/ test("28,bjb,g9a", "16");
  /*10*/ test("20,2i9d,5id4", "24");
  /*11*/ test("5,12000,24141", "24");
  /*12*/ test("6,1245,5145", "28");
  /*13*/ test("36,1,z", "35");
  /*14*/ test("14,277,dc1", "42");
  /*15*/ test("35,9iy,l5p", "44");
  /*16*/ test("17,7be,19b1", "44");
  /*17*/ test("18,96f,236g", "52");
  /*18*/ test("23,b1f,1k81", "56");
  /*19*/ test("6,143424,353115", "64");
  /*20*/ test("5,3401,40123", "67");
  /*21*/ test("4,321,123022", "102");
  /*22*/ test("13,1b0,8a72", "108");
  /*23*/ test("20,62,339f", "124");
  /*24*/ test("24,f8h,bcn0", "124");
  /*25*/ test("31,do3,78no", "124");
  /*26*/ test("17,727,ced4", "136");
  /*27*/ test("5,14,222243", "154");
  /*28*/ test("16,3c5,100bb", "168");
  /*29*/ test("9,353,80016", "200");
  /*30*/ test("21,h7d,34504", "220");
  /*31*/ test("11,20a,78926", "224");
  /*32*/ test("12,b0,77996", "238");
  /*33*/ test("3,212,11112012", "254");
  /*34*/ test("22,6f2,789hd", "340");
  /*35*/ test("36,5l6,tvmw", "352");
  /*36*/ test("25,db8,99b08", "376");
  /*37*/ test("32,hpi,556a7", "376");
  /*38*/ test("29,1cl,456d2", "396");
  /*39*/ test("34,dli,455u7", "404");
  /*40*/ test("15,ced,3345c1", "424");
  /*41*/ test("30,601,7780o", "428");
  /*42*/ test("3,22,22000021", "445");
  /*43*/ test("5,440,4012303", "446");
  /*44*/ test("27,hg,aaamk", "480");
  /*45*/ test("33,suv,defn7", "480");
  /*46*/ test("2,11,111101110", "492");
  /*47*/ test("35,60e,9aamd", "528");
  /*48*/ test("7,33,3445635", "542");
  /*49*/ test("4,120,22330013", "550");
  /*50*/ test("23,8fk,lm066", "564");
  /*51*/ test("6,142,5001252", "568");
  /*52*/ test("8,111,3344567", "572");
  /*53*/ test("26,4na,klmib", "600");
  /*54*/ test("19,32a,6678g3", "672");
  /*55*/ test("7,605,6011223", "680");
  /*56*/ test("6,15,11235050", "692");
  /*57*/ test("9,664,5567833", "746");
  /*58*/ test("10,909,4556846", "746");
  /*59*/ test("10,991,5555766", "769");
  /*60*/ test("8,757,7700001", "812");
  /*61*/ test("36,6pku,27wr28", "856");
  /*62*/ test("35,6n89a,j1dlik", "1024");
  /*63*/ test("34,7gehm,m0anuo", "1088");
  /*64*/ test("10,3268665,134217728", "1856");
  /*65*/ test("11,571016a,47352388a", "2624");
  /*66*/ test("4,10030022033,10203020123103", "21504");
  /*67*/ test("3,22111101011101,11021122211120221", "100352");
  /*68*/ test("2,101001011010110000110101,110101110001110110110101", "3240321");
}

#include <stdio.h>
#include <caml/callback.h>

extern int fib(int n);
extern char * format_result(int n);

int main(int argc, char ** argv)
{
  int result;

  caml_startup(argv);
  result = fib(10);
  printf("fib(10) = %s\n", format_result(result));
  return 0;
}

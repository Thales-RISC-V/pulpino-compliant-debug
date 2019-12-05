// Copyright 2017 ETH Zurich and University of Bologna.
// Copyright and related rights are licensed under the Solderpad Hardware
// License, Version 0.51 (the “License”); you may not use this file except in
// compliance with the License.  You may obtain a copy of the License at
// http://solderpad.org/licenses/SHL-0.51. Unless required by applicable law
// or agreed to in writing, software, hardware and materials distributed under
// this License is distributed on an “AS IS” BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.


#include <stdio.h>

int main()
{
uart_set_cfg(0, 0x28a);
  printf("Hello World!!!!!\n\r");
   printf ("Characters: %c %c \n\r", 'a', 65);
   printf ("Decimals: %d %ld\n\r", 1977, 650000L);
   printf ("Preceding with blanks: %10d \n\r", 1977);
   printf ("Preceding with zeros: %010d \n\r", 1977);
   printf ("Some different radices: %d %x %o %#x %#o \n\r", 100, 100, 100, 100, 100);
   printf ("floats: %4.2f %+.0e %E \n\r", 3.1416, 3.1416, 3.1416);
   printf ("Width trick: %*d \n\r", 5, 10);
   printf ("%s \n\r", "A string");
  return 0;
}

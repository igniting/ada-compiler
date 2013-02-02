procedure Array_Test is
A: array (1..100) of Integer;
 begin
   A(3) := 56.2;
   A[3] := 56;  -- illegal character '['
 end Array_Test;


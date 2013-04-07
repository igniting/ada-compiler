-- Ada Hello, World! program.
with Text_IO; use Text_IO;      -- This gets the IO facility.
procedure Hello is              -- Main, but no special name is needed.
      Mike, Alice: Integer;
      Mike: constant := 2.0*Ada.Numerics.Pi;
begin
   Put_Line("Hello, World!");   -- Put_Line is from Text_IO.
   Swp: 
    declare 
        Temp : Integer; 
        begin 
            Temp := V; V := U; U := Temp; 
    end Swp;
end Hello;

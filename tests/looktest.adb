
--  illustrates use of Get_Line and Look_Ahead

with Ada.Text_IO; use Ada.Text_IO;
procedure Looktest is
   I : Integer := 0;
   C : Character;
   Buf : String (1..10);
   Last : Integer;
   EOL : Boolean;
begin
   loop
      Get_Line (Buf , Last);
      Put (Buf(1 .. Last));
      if Last = Buf'Last then
         Look_Ahead (C, EOL);
         if EOL then Put_Line ("*");
            Skip_Line;
         end if;
      else
         Put_Line (".");
      end if;
   end loop;
exception
   when End_Error =>
      Put_Line ("end_error");
end Looktest;

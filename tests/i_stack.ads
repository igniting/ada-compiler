--
-- A simple array-based stack package.  Of course, it has a size
-- limit.  The operations are what you would expect:
--   Int_Stack  : Type of stack variables.
--   Push       : Push the integer on the stack.
--   Pop        : Pop the integer and place the result in the parameter.
--                If empty, puts zero and leaves stack unchanged.
--   Top        : Return the top of the stack, or 0 if there is none.
--   Empty      : See if the stack is empty.
--   Full       : See if the stack is full.
--   Clean      : Make the stack empty.
--
-- This has some similarity to a class, but it is not a blueprint for
-- objects.  Its main purpose is to control access to declarations.
-- A class can contain a type declaration (or several).  These types serve
-- the "blueprint" role.
--
-- This file is a package declaration.  It is named int_stack.ads; the
-- .ads extension is what Gnat expects for files containing such declarations.
-- Also note that you do not need to compile this file.  (In fact, it will
-- complain if you try.)  This file is read automatically when the compiler
-- sees a with clause, or when the body file (int_stack.adb) is compiled.
--
package I_Stack is
   -- This declares that Int_Stack is a type, but the contents of the type
   -- are private, and are invisible to clients of the package.
   type Int_Stack is private;

   -- Max stack size.
   Max_Size: constant Integer := 100;

   -- All the public stack operations.
   procedure Push(S: in out Int_Stack; I: Integer);
   procedure Pop(S: in out Int_Stack; I: out Integer);
   function Top(S: Int_Stack) return Integer;
   function Empty(S: Int_Stack) return Boolean;
   function Full(S: Int_Stack) return Boolean;
   procedure Clean(S: in out Int_Stack);

   private
      -- The items here cannot be accessed by clients of the package.
      type Stack_Data_Type is array(1..Max_Size) of Integer;
      type Int_Stack is record
         Size: Integer := 0;
         Data: Stack_Data_Type;
      end record;
end I_Stack;

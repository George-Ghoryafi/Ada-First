with Ada.Text_IO; use Ada.Text_IO;

procedure Ascii_Test is
   Dashed : constant Character := '-';
   Line : constant Character := '|';

   function Make_Box (Width : Integer; Height : Integer) return String is
      -- The total size of the box string (including newlines)
      Box_Length : constant Integer := (Width + 1) * Height; -- +1 for newline
      Result : String (1 .. Box_Length); -- Fixed-length string to store the box
      Index : Integer := 1; -- Tracks the current position in the Result string
   
   begin
      -- We'll begin by going row by row 
      for Row in 1 .. Height loop
         -- First we want to check if we're on the top or bottom row (these are where the horizontal dashes go) 
         if Row = 1 or Row = Height then
            -- Fill in the result with dashes if appropriate
            for Col in 1 .. Width loop
               Result(Index) := Dashed;
               Index := Index + 1;
            end loop;
         else
            -- Now handling the horizontal borders (vertical lines with spaces in between)
            
            Result(Index) := Line; -- Left border
            Index := Index + 1; -- Move to the next position
            
            -- Looping through the columns to add empty spaces
            for Col in 2 .. Width - 1 loop 
               Result(Index) := ' '; 
               Index := Index + 1;
            end loop;


            Result(Index) := Line; -- Right border
            Index := Index + 1; -- Move to the next position
         end if;

         -- Could replace ASCII.LF with Character'Val(10), just found this interesting way of doing it instead
         -- This is simply creating a bunch of space between our left and right vertical borders 
         Result(Index) := ASCII.LF;
         Index := Index + 1;
      end loop;

      -- Finally return the generated box so we can print it out later
      return Result;
   end Make_Box;

begin
   declare
      -- Creating our paramters for the box
      Width : constant Integer := 20;
      Height : constant Integer := 10;

      -- Generating the box with the parameters from above
      Box : String := Make_Box(Width, Height);
   begin
      -- Finally we print out the box that we generated above 
      Put(Box);
   end;
end Ascii_Test;

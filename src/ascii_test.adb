with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure Ascii_Test is
   Dashed : constant Character := '-';
   Line : constant Character := '|';

   -- Most annoying thing I have found -- Semi colon, not commas...
   function Make_Box (Width : Integer; Height : Integer; Avatar: Character; Avatar_Row: Integer; Avatar_Col: Integer; Food_Row: Integer; Food_Col: Integer; Food_Char: Character) return String is
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
         -- Reminder to self :: Everything above this line so far has nothing to do with the Avatar 
         
         else
            -- Now handling the horizontal borders (vertical lines with spaces in between)
            -- And handling the Avatar's positioning
            Result(Index) := Line; -- Left border
            Index := Index + 1; -- Move to the next position
            
            -- Looping through the columns to add empty spaces
            for Col in 2 .. Width - 1 loop 
               -- Start handling Avatar's positioning
               if Row = Avatar_Row and Col = Avatar_Col then 
                  -- If we're at the Avatar's position, add the Avatar to the box
                  Result(Index) := Avatar;
               elsif Row = Food_Row and Col = Food_Col then
                  -- If we're at the Food's position, add the Food to the box
                  Result(Index) := Food_Char;
               else
                  -- Otherwise, add a space
                  Result(Index) := ' '; 
               end if;
               Index := Index + 1; -- Move to the next position
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

   procedure Handle_Moves is 
      -- (CONSTANTS) Creating our paramters for the box
      Width : constant Integer := 20;
      Height : constant Integer := 10;
      Avatar : constant Character := '@';
      Food_Char : constant Character := '*';
      
      
      -- Avatar's Initial Position
      Avatar_Row : Integer := 5;
      Avatar_Col : Integer := 10; 

      -- Food's Initial Position
      Food_Row : Integer := 5;
      Food_Col : Integer := 5;
      
      -- Using Input to store the user's input to allow them to move the avatar
      Input : Character;     
      Score : Integer := 0; -- Keeping track of the user's score

      package Random is new Ada.Numerics.Discrete_Random (Integer); 
      Gen : Random.Generator;

   begin
         loop 
         -- We start by clearing the screen of any previous boxes (Basically just adding a new line for clarity)
         -- I want to change this to clearing the terminal entirely, couldn't find anything online about that though
         Put_Line(""); 

         -- Can now generate the box with the Avatar in it
         -- Note to self :: Box generation is here, no need to call it again in the main procedure
         Put(Make_Box(Width, Height, Avatar, Avatar_Row, Avatar_Col, Food_Row, Food_Col, Food_Char));

         Put_Line("Current Score: " & Score'Image); -- Display the user's current score

         -- Now we need to ask the user what move they want to make, read the result, and store in Input
         Put("Enter a move (w/a/s/d), or q to quit: ");
         Get(Input);

         -- Now we do a case statement to handle the user's input
         case Input is 
            when 'w' =>
               -- Handle moves that may result in out of bounds
               if Avatar_Row > 2 then 
                  Avatar_Row := Avatar_Row - 1;
               end if;
            when 's' =>
               if Avatar_Row < Height - 1 then 
                  Avatar_Row := Avatar_Row + 1;
               end if;
            when 'a' =>
               if Avatar_Col > 2 then 
                  Avatar_Col := Avatar_Col - 1;
               end if;
            when 'd' =>
               if Avatar_Col < Width - 1 then 
                  Avatar_Col := Avatar_Col + 1;
               end if;
            when 'q' =>
               Put("FInal Score: " & Score'Image);
               exit;
            when others =>
               Put_Line("Invalid move. Please enter w, a, s, d to make a move on the board, or q to exit.");
            end case; 

               -- Checking if Avatar and Food overlap (if they do, we need to move the food and find it a new home)
               if Avatar_Row = Food_Row and Avatar_Col = Food_Col then
                  -- Using the random number generator and a generator Object we got before, we get the food's new position
                  Food_Row := Random.Random(Gen, 2, Height - 1);
                  Food_Col := Random.Random(Gen, 2, Width - 1);
                  Score := Score + 1; -- Increment the score
               end if;            
         end loop; 
   end Handle_Moves;
begin
   -- Simply call handle moves to start the game (it takes care of the drawing as well)
   Handle_Moves;
end Ascii_Test;
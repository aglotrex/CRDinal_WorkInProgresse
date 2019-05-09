package body UxAS.Messages.Lmcptask.TaskOption.SPARK_Boundary with SPARK_Mode => Off is

   
   --------------------------
   -- Get_EligibleEntities --
   --------------------------
   
   function Get_EligibleEntities (This : My_TaskOption) return Int64_Vect
   is
      L : constant UxAS.Messages.Lmcptask.TaskOption.Vect_Int64_Acc := 
        This.Content.GetEligibleEntities;
   begin
      return R : Int64_Vect do
         for E of L.all loop
            Int64_Vects.Append(Container => R,
                               New_Item  => E);
         end loop;
      end return;
   end Get_EligibleEntities;
   
   

end UxAS.Messages.Lmcptask.TaskOption.SPARK_Boundary;

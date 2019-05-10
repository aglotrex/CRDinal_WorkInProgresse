package body UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary with SPARK_Mode => Off is

   function Get_CostMatrix 
     (This : My_AssignmentCostMatrix) return Vect_My_TaskOptionCost
   is 
      L : UxAS.Messages.Lmcptask.AssignmentCostMatrix.Vect_TaskOptionCost_Acc_Acc :=
        This.Content.GetCostMatrix;
   begin
      return R : Vect_My_TaskOptionCost do
         for E in L.all loop
            Vect_My_TaskOptionCost_V.Append(Container => R,
                                            New_Item  => Wrap (E));
         end loop;
      end return;
   end Get_CostMatrix;
   
   
   procedure Add_TaskOptionCost_To_CostMatrix
     (This : in out My_AssignmentCostMatrix;
      TaskOptionCost : My_TaskOptionCost)
   is 
      Task_Option_Cost_Acc : TaskOptionCost_Acc := new TaskOptionCost;
   begin
      Task_Option_Cost_Acc.all := Unwrap(My_TaskOptionCost); 
      This.Content.GetCostMatrix.Append(New_Item => Task_Option_Cost_Acc);
     
   end Add_TaskOptionCost_To_CostMatrix;

end UxAS.Messages.Lmcptask.ASsignmentCostMatrix.SPARK_Boundary;

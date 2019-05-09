package body UxAS.Messages.Lmcptask.TaskPlanOptions.SPARK_Boundary with SPARK_Mode => Off is

   
  function Get_Options
     (This : My_TaskPlanOptions) return Vect_My_TaskOption 
   is
      L : constant Uxas.Messages.Lmcptask.TaskPlanOptions.Vect_TaskOption_Acc_Acc :=
        This.Content.GetOptions;
   begin
      return R : Vect_My_TaskOption do
         for E of L.all loop
            Vect_My_TaskOptions.Append(R, Wrap(E.all));
         end loop;
      end return;
   end Get_Options;
   
        
end UxAS.Messages.Lmcptask.TaskPlanOptions.SPARK_Boundary;

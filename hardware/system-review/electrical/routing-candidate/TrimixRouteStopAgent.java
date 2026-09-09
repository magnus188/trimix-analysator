import java.lang.instrument.Instrumentation;
/** Local router-only bounded-stop helper. Uses published public methods; no PCB edits. */
public class TrimixRouteStopAgent {
 public static void agentmain(String args, Instrumentation inst) throws Exception {
  Class<?> schedulerClass=Class.forName("app.freerouting.management.RoutingJobScheduler");
  Object scheduler=schedulerClass.getMethod("getInstance").invoke(null);
  Object[] jobs=(Object[])schedulerClass.getMethod("listJobs").invoke(scheduler);
  for(Object job:jobs){
   Object settings=job.getClass().getField("routerSettings").get(job);
   int current=(int)settings.getClass().getMethod("get_start_pass_no").invoke(settings);
   settings.getClass().getMethod("set_stop_pass_no",int.class).invoke(settings,current);
   System.out.println("TRIMIX bounded-stop requested after current pass "+current);
  }
 }
 public static void main(String[] args) throws Exception {
  final int max=Integer.parseInt(args[0]);
  String[] cli=java.util.Arrays.copyOfRange(args,1,args.length);
  Thread guard=new Thread(()->{
   try {
    Class<?> sc=Class.forName("app.freerouting.management.RoutingJobScheduler");
    Object scheduler=sc.getMethod("getInstance").invoke(null);
    boolean announced=false;
    while(true){
     Object[] jobs=(Object[])sc.getMethod("listJobs").invoke(scheduler);
     for(Object job:jobs){
      Object settings=job.getClass().getField("routerSettings").get(job);
      settings.getClass().getMethod("set_stop_pass_no",int.class).invoke(settings,max);
      Object board=job.getClass().getField("board").get(job);
      if(board!=null){
       Object rules=board.getClass().getField("rules").get(board);
       Object classes=rules.getClass().getField("net_classes").get(rules);
       Object power=classes.getClass().getMethod("get",String.class).invoke(classes,"power_manual");
       if(power!=null)power.getClass().getField("is_ignored_by_autorouter").setBoolean(power,true);
       Object distribution=classes.getClass().getMethod("get",String.class).invoke(classes,"power_distribution");
       if(distribution!=null){
        distribution.getClass().getMethod("set_active_routing_layer",int.class,boolean.class).invoke(distribution,1,false);
        distribution.getClass().getMethod("set_active_routing_layer",int.class,boolean.class).invoke(distribution,2,false);
       }
       settings.getClass().getMethod("set_layer_active",int.class,boolean.class).invoke(settings,1,false);
       if(!announced){System.out.println("TRIMIX runtime settings: stopPass="+max+", power_manual ignored, In1 inactive");announced=true;}
      }
     }
     Thread.sleep(50);
    }
   }catch(Throwable e){e.printStackTrace();System.exit(2);}
  });
  guard.setDaemon(true);guard.start();
  Class.forName("app.freerouting.Freerouting").getMethod("main",String[].class).invoke(null,(Object)cli);
 }
}

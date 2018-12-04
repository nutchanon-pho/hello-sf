public class TestBatch implements Database.Batchable<String>, Database.AllowsCallouts {
    
    List<String> stringList;
    
    public TestBatch(List<String> stringList){
       this.stringList = stringList;
    }
    
	public Iterable<String> start (Database.BatchableContext BC) {
		return stringList;
    }
    
    public void execute (Database.BatchableContext BC, List<String> scope) {
        System.debug('execute ' + scope);
        for(String s : scope){
            System.debug(s);
        }
    }

    public void finish (Database.BatchableContext BC) {

    }
}
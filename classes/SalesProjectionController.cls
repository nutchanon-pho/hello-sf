global class SalesProjectionController {
    global class Data implements Comparable{
        String name;
        Decimal amount;
        Integer sortingValue;
        String formattedAmount;
        
        public Data(String name, Decimal amount, Integer sortingValue){
            this.name = name;
            this.amount = amount;
            this.sortingValue = sortingValue;
            formatAmount();
        }
        
        public void addAmount(Decimal additionalAmount){
            amount += additionalAmount;
            formatAmount();
        }
        
        global Integer compareTo(Object otherData){
            return this.sortingValue - ((Data)otherData).sortingValue;
        }
        
        private void formatAmount(){
            String i = String.valueOf(amount);
            String s = ( Decimal.valueOf(i==null||i.trim()==''?'0':i).setScale(2) + 0.001 ).format();
            formattedAmount = s.substring(0,s.length()-1);
        }
    }
    
    public List<Data> getData(){
        List<String> monthList = new List<String>{'January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'};
        final Integer NUMBER_OF_MONTH = 12;
        List<Opportunity> oppList = [SELECT Id, Amount, Start_Date__c, Duration__c 
                                     FROM Opportunity 
                                     WHERE Start_Date__c != null AND Duration__c != null];

        Map<String, Data> dataMapByMonthYear = new Map<String, Data>();
        for(Opportunity opp : oppList){
            Date startDateOfThisOpp = opp.Start_Date__c;
            Integer yearOfTheStartDate = startDateOfThisOpp.year();
            Integer startingMonthIndex = startDateOfThisOpp.month() - 1;
            Decimal duration = opp.Duration__c;
            Decimal fullAmount = opp.Amount;
            Decimal amountForEachDuration = (fullAmount/duration).setScale(2);
            
            for(Integer i=0;i<duration;i++){
                String startingMonthName = monthList.get(startingMonthIndex);
                String monthYear = startingMonthName + ' ' + yearOfTheStartDate;
                if(dataMapByMonthYear.containsKey(monthYear)){
                    Data dataOfThisMonthYear = dataMapByMonthYear.get(monthYear);
                    dataOfThisMonthYear.addAmount(amountForEachDuration);
                } else {
                 	Data newData = new Data(monthYear, amountForEachDuration, getSortingValue(yearOfTheStartDate, startingMonthIndex)); 
                    dataMapByMonthYear.put(monthYear, newData);
                }
                startingMonthIndex++;
                if(startingMonthIndex == NUMBER_OF_MONTH){
                    startingMonthIndex = 0;
                    yearOfTheStartDate++;
                }
            }
        }
        List<Data> dataList = dataMapByMonthYear.values();
		dataList.sort();
        return dataList;
    }
    
    private Integer getSortingValue(Integer year, Integer month){
        if(month < 10){
            return Integer.valueOf(year + '0' + month);
        } else {
            return Integer.valueOf(year + '' + month);
        }
    }
}
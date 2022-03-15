public class AccountBatchSchedule implements Schedulable{
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new BatchUpdateAccountWeatherField());
    }
}

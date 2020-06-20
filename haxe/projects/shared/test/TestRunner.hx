
import shared.Shared;
import utest.Runner;
import utest.ui.Report;

class TestRunner {
    public static function main() {
        //the long way
        Shared.load();
        var runner = new Runner();
        Report.create(runner);
        runner.run();

    }
}

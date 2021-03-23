<?php
require 'vendor/autoload.php';
use App\Result;
use App\ResultItem;
use App\Engine\Wikipedia\WikipediaEngine;
use App\Engine\Wikipedia\WikipediaParser;
use Symfony\Component\Console\Application;
use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputArgument;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\HttpClient\HttpClient;
use Symfony\Component\Console\Formatter\OutputFormatterStyle;
use Symfony\Component\Console\Helper\Table;

class GreetCommand extends Command
{
    protected function configure()
    {
        $this
            ->setName('greet')
            ->setDescription('Greet the given person name')
            ->addArgument('name', InputArgument::REQUIRED, 'The person name');
    }
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $wikipedia = new WikipediaEngine(new WikipediaParser(), HttpClient::create());
        $result = $wikipedia->search($input->getArgument('name'));

        $output->writeln("<fg=yellow>". str_pad("",198,"=")."</>");
        $output->writeln("<fg=yellow>". $result->count() . " results was found for term '".$input->getArgument('name')."' on 'wikipedia'</>");
        $output->writeln("<fg=yellow>". str_pad("",198,"=")."</>");

        $output->writeln("Showing first 20 results:");

        
        //$output->writeln(str_pad("",27,"-"). " ". str_pad("",173,"-"));
        //$output->writeln("<fg=green> Title</>". str_pad("",23," ") . "<fg=green>Preview</>");
        //$output->writeln(str_pad("",27,"-"). " ". str_pad("",173,"-"));


        foreach($result as $resultItem){
        //        $output->writeln(str_pad($resultItem->getTitle(),28) . " " . $resultItem->getPreview());
                $rows[] = [$resultItem->getTitle(), $resultItem->getPreview()];
        }

        //$output->writeln(str_pad("",27,"-"). " ". str_pad("",173,"-"));

        $table = new Table($output);
        $table
            ->setHeaders(['Title','Preview'])
            ->setRows($rows);
        $table->render();





        return 0;
    }
}
$app = new Application();
$app->add(new GreetCommand());
$app->run();

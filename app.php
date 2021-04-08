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

class SearchCommand extends Command
{
    protected function configure()
    {
        $this
            ->setName('searchWikipedia')
            ->setDescription('Search the given term in Wikipedia')
            ->addArgument('name', InputArgument::REQUIRED, 'The term name');
    }
    protected function execute(InputInterface $input, OutputInterface $output)
    {
        $wikipedia = new WikipediaEngine(new WikipediaParser(), HttpClient::create());
        $result = $wikipedia->search($input->getArgument('name'));

        if(count($result) === 0)
        {
            $output->writeln("<fg=red>". str_pad("",198,"=")."</>");
            $output->writeln("<fg=red>". "No results found for term '".$input->getArgument('name')."' on 'wikipedia'</>");
            $output->writeln("<fg=red>". str_pad("",198,"=")."</>");
            return 0;  
       }

        $output->writeln("<fg=yellow>". str_pad("",198,"=")."</>");
        $output->writeln("<fg=yellow>". $result->count() . " result(s) was found for term '".$input->getArgument('name')."' on 'wikipedia'</>");
        $output->writeln("<fg=yellow>". str_pad("",198,"=")."</>");

        $output->writeln("Showing first ". $result->countItemsOnPage() . " result(s):");

        foreach($result as $resultItem){
                $rows[] = [$resultItem->getTitle(), $resultItem->getPreview()];
        }

        $table = new Table($output);
        $table
            ->setHeaders(['Title','Preview'])
            ->setRows($rows);
        $table->render();

        return 0;
    }
}
$app = new Application();
$app->add(new SearchCommand());
$app->run();

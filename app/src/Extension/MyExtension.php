<?php
namespace Mutoco\Extension;

use SilverStripe\ORM\DataExtension;

class MyExtension extends DataExtension
{
    private static $db = [
        'Version' => 'Int'
    ];


}

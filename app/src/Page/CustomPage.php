<?php

namespace Mutoco\Page;


use SilverStripe\CMS\Model\SiteTree;
use SilverStripe\Forms\FieldList;
use SilverStripe\Forms\TextField;
use SilverStripe\ORM\DB;
use SilverStripe\Versioned\Versioned;

class CustomPage extends \Page
{
	private static $table_name = 'Mutoco_CustomPage';
	private static $icon_class = 'font-icon-p-articles';

    private static $db = [
        'CustomField' => 'Varchar(255)'
    ];

    public function getCMSFields()
    {
        $this->beforeUpdateCMSFields(function (FieldList $fields) {
            $fields->addFieldToTab('Root.Main', Textfield::create('CustomField', $this->fieldLabel('CustomField')), 'Content');
        });

        return parent::getCMSFields();
    }

    public function requireDefaultRecords()
    {
        parent::requireDefaultRecords();
        if (static::class === self::class) {
            if (!SiteTree::get_by_link('custom-page')) {
                $customPage = new CustomPage();
                $customPage->Title = 'My Custom Page';
                $customPage->Content = '<p>My custom content</p>';
                $customPage->URLSegment = 'custom-page';
                $customPage->CustomField = 'custom field content';
                $customPage->Sort = 1;
                $customPage->write();
                $customPage->copyVersionToStage(Versioned::DRAFT, Versioned::LIVE);
                $customPage->flushCache();
                DB::alteration_message('Custom page created', 'created');
            }
        }
    }
}

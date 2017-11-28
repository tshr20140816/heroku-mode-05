<?php

$template_number = $_GET['n'];

$data = explode("\n", file_get_contents(getenv('RSS_TEMPLATE_URL') . "${template_number}.txt"));
$url = $data[0];
$encoding = $data[1];
$global_pattern = '/' . $data[2] . '/s';
$item_pattern = '/' . $data[3] . '/s';
$feed_title = $data[4];
$feed_link = $data[5];
$item_title = $data[6];
$item_link = $data[7];
$item_description = $data[8];

$items_template = "<item><title>__TITLE__</title><link>__LINK__</link><description>__DESCRIPTION__</description><pubDate/></item>";

$html = mb_convert_encoding(file_get_contents($url), 'UTF-8', $encoding);

$rc = preg_match($global_pattern, $html, $matches1);

$items = array();

$rc = preg_match_all($item_pattern, $matches1[1], $matches2, PREG_SET_ORDER);
for ($i = 0; $i < $rc; $i++) {
  $title = $item_title;
  $link = $item_link;
  $description = $item_description;
  for ($j = 1; $j < count($matches2[$i]); $j++) {
    $title = str_replace('__' . $j . '__', $matches2[$i][$j], $title);
    $link = str_replace('__' . $j . '__', $matches2[$i][$j], $link);
    $description = str_replace('__' . $j . '__', $matches2[$i][$j], $description);
  }
  $tmp = str_replace('__TITLE__', $title, $items_template);
  $tmp = str_replace('__LINK__', $link, $tmp);
  $tmp = str_replace('__DESCRIPTION__', $description, $tmp);
  $items[] = $tmp;
}

$xml_root_text = <<< __HEREDOC__
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>${feed_title}</title>
    <link>${feed_link}</link>
    <description/>
    <language>ja</language>
    __ITEMS__
  </channel>
</rss>
__HEREDOC__;

header('Content-Type: application/xml; charset=UTF-8');
echo str_replace('__ITEMS__', implode("\r\n", $items), $xml_root_text);
?>
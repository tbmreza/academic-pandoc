local REFS =
     '<w:headerReference w:type="even" r:id="rId8"/>'
  .. '<w:headerReference w:type="default" r:id="rId9"/>'
  .. '<w:footerReference w:type="even" r:id="rId10"/>'
  .. '<w:footerReference w:type="default" r:id="rId11"/>'
  .. '<w:headerReference w:type="first" r:id="rId12"/>'
  .. '<w:footerReference w:type="first" r:id="rId13"/>'

local MAR = '<w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720"'
         .. ' w:header="720" w:footer="720" w:gutter="0"/>'

local portrait = '<w:p><w:pPr><w:sectPr>' .. REFS
  .. '<w:pgSz w:w="11906" w:h="16838" w:code="9"/>' .. MAR
  .. '</w:sectPr></w:pPr></w:p>'

local landscape = '<w:p><w:pPr><w:sectPr>' .. REFS
  .. '<w:pgSz w:w="16838" w:h="11906" w:orient="landscape" w:code="9"/>' .. MAR
  .. '</w:sectPr></w:pPr></w:p>'

function Div(el)
  if el.classes:includes('landscape') then
    local out = pandoc.List({ pandoc.RawBlock('openxml', portrait) })
    out:extend(el.content)
    out:insert(pandoc.RawBlock('openxml', landscape))
    return out
  end
end

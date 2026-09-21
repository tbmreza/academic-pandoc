local function section_properties(orientation)
  if orientation == "landscape" then
    return [[
<w:sectPr>
  <w:type w:val="nextPage"/>
  <w:pgSz w:w="15840" w:h="12240" w:orient="landscape"/>
  <w:pgMar w:top="720" w:right="720" w:bottom="720" w:left="720"/>
</w:sectPr>
]]
  else
    return [[
<w:sectPr>
  <w:type w:val="nextPage"/>
  <w:pgSz w:w="12240" w:h="15840"/>
  <w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440"/>
</w:sectPr>
]]
  end
end

function Div(el)
  if not el.classes:includes("landscape") then
    return nil
  end

  return pandoc.RawBlock("openxml", [[
<w:p>
  <w:pPr>
    ]] .. section_properties("portrait") .. [[
  </w:pPr>
</w:p>

<w:p>
  <w:r>
    <w:t>[INSERT SPREADSHEET OBJECT HERE]</w:t>
  </w:r>
</w:p>

<w:p>
  <w:pPr>
    ]] .. section_properties("landscape") .. [[
  </w:pPr>
</w:p>
]])
end

local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local filename_no_ext = function()
	return vim.fn.expand("%:t:r")
end

ls.add_snippets("html", {
	s("!", {
		t({ "<!DOCTYPE html>", '<html lang="en">', "<head>" }),
		t({ "", '    <meta charset="UTF-8">' }),
		t({ "", '    <meta name="viewport" content="width=device-width, initial-scale=1.0">' }),
		t({ "", "    <title>" }),
		i(1, "Document"),
		t({ "</title>", "  </head>", "  <body>" }),
		t({ "", "    <h1>Hello, world!</h1>" }),
		t({ "", "    <!-- Add your content here -->" }),
		t({ "", "  </body>", "</html>" }),
	}),
})
-- Add snippets to specific filetypes
ls.add_snippets("javascriptreact", {
	s("rsc", {
		t("const "),
		f(filename_no_ext, {}),
		t(" = () => {"),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(1),
		t({ "", "    </div>", "  );", "};", "", "export default " }),
		f(filename_no_ext, {}),
		t(";"),
	}),
	s("rc", {
		t("import { classNames } from '@/shared/lib/classNames/classNames';"),
		t({ "", "import cls from './" }),
		f(filename_no_ext, {}),
		t(".module.scss';", "", ""),
		t("interface "),
		f(filename_no_ext, {}),
		t("Props {"),
		t({ "", "  className?: string;", "}", "", "export const " }),
		f(filename_no_ext, {}),
		t(" = ({ className }: "),
		f(filename_no_ext, {}),
		t("Props) => {"),
		t({ "", "  return (" }),
		t({ "", "    <div className={classNames(cls." }),
		f(filename_no_ext, {}),
		t(", {}, [className])}>"),
		i(0),
		t({ "", "    </div>", "  );", "};" }),
	}),
})

ls.add_snippets("typescriptreact", {
	s("rsc", {
		t("const "),
		f(filename_no_ext, {}),
		t(" = () => {"),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(1),
		t({ "", "    </div>", "  );", "};", "", "export default " }),
		f(filename_no_ext, {}),
		t(";"),
	}),
	s("rc", {
		t("import { classNames } from '@/shared/lib/classNames/classNames';"),
		t({ "", "import cls from './" }),
		f(filename_no_ext, {}),
		t(".module.scss';", "", ""),
		t("interface "),
		f(filename_no_ext, {}),
		t("Props {"),
		t({ "", "  className?: string;", "}", "", "export const " }),
		f(filename_no_ext, {}),
		t(" = ({ className }: "),
		f(filename_no_ext, {}),
		t("Props) => {"),
		t({ "", "  return (" }),
		t({ "", "    <div className={classNames(cls." }),
		f(filename_no_ext, {}),
		t(", {}, [className])}>"),
		i(0),
		t({ "", "    </div>", "  );", "};" }),
	}),
})

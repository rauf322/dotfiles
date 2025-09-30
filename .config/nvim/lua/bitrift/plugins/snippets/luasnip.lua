local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local filename_no_ext = function()
	return vim.fn.expand("%:t:r")
end

-- Define snippets
ls.add_snippets("html", {
	s("html", {
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

-- Define JS/TS snippets once
local js_snippets = {
	s("!func", {
		t("function "),
		f(filename_no_ext),
		t("() {"),
		t({ "", "  " }),
		i(1, "// your code here"),
		t({ "", "}", "", "", "console.log(" }),
		f(filename_no_ext),
		t("());"),
	}),
	s("clg", {
		t("console.log("),
		i(1),
		t(")"),
	}),
	s("<", {
		t("<"),
		i(1, "Component"),
		t(" />"),
	}),
	s("comp", {
		t("<"),
		i(1, "Component"),
		t(" />"),
	}),
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
	s("tst", {
		t("import { createFileRoute } from '@tanstack/react-router'"),
		t({ "", "", "export const Route = createFileRoute('/" }),
		i(1, "path"),
		t("')({"),
		t({ "", "  component: " }),
		f(filename_no_ext, {}),
		t(","),
		t({ "", "})", "", "function " }),
		f(filename_no_ext, {}),
		t("() {"),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(0),
		t({ "", "    </div>", "  )", "}" }),
	}),
	s("routeloader", {
		t("import { createFileRoute } from '@tanstack/react-router'"),
		t({ "", "", "export const Route = createFileRoute('/" }),
		i(1, "path"),
		t("')({"),
		t({ "", "  loader: async () => {" }),
		t({ "", "    " }),
		i(2, "// loader logic"),
		t({ "", "  }," }),
		t({ "", "  component: " }),
		f(filename_no_ext, {}),
		t(","),
		t({ "", "})", "", "function " }),
		f(filename_no_ext, {}),
		t("() {"),
		t({ "", "  const data = Route.useLoaderData()" }),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(0),
		t({ "", "    </div>", "  )", "}" }),
	}),
	s("routeparams", {
		t("import { createFileRoute } from '@tanstack/react-router'"),
		t({ "", "", "export const Route = createFileRoute('/" }),
		i(1, "path/$id"),
		t("')({"),
		t({ "", "  component: " }),
		f(filename_no_ext, {}),
		t(","),
		t({ "", "})", "", "function " }),
		f(filename_no_ext, {}),
		t("() {"),
		t({ "", "  const { " }),
		i(2, "id"),
		t(" } = Route.useParams()"),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(0),
		t({ "", "    </div>", "  )", "}" }),
	}),
	s("layout", {
		t("import { createFileRoute, Outlet } from '@tanstack/react-router'"),
		t({ "", "", "export const Route = createFileRoute('/" }),
		i(1, "_layout"),
		t("')({"),
		t({ "", "  component: LayoutComponent," }),
		t({ "", "})", "", "function LayoutComponent() {" }),
		t({ "", "  return (" }),
		t({ "", "    <div>" }),
		i(2, "<!-- Layout content -->"),
		t({ "", "      <Outlet />" }),
		t({ "", "    </div>", "  )", "}" }),
		i(0),
	}),
}

-- Apply snippets to all JS/TS filetypes
for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
	ls.add_snippets(ft, js_snippets)
end

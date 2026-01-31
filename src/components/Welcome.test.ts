import { experimental_AstroContainer as AstroContainer } from "astro/container";
import { expect, test } from "vitest";
import Welcome from "./Welcome.astro";

test("Welcome renders and contains key content", async () => {
	const container = await AstroContainer.create();
	const html = await container.renderToString(Welcome);
	expect(html).toContain("src/pages");
	expect(html).toContain("Read our docs");
});

import { expect, test } from "@playwright/test";

test("home page loads with correct title and content", async ({ page }) => {
	await page.goto("/");
	await expect(page).toHaveTitle("Astro Basics");
	await expect(page.getByRole("link", { name: "Read our docs" })).toBeVisible();
});

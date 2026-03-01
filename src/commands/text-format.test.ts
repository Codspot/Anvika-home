import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("anvika", 16)).toBe("anvika");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("anvika-status-output", 10)).toBe("anvika-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});

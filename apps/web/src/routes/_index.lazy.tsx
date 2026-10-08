import { createLazyFileRoute } from "@tanstack/react-router";
import { useEffect, useState } from "react";

import { FeaturesSection } from "@/routes/home/-features";
import { HomeFooter } from "@/routes/home/-footer";
import { FooterCTA } from "@/routes/home/-footer-cta";
import { HeroSection } from "@/routes/home/-hero";
import { HomeNav } from "@/routes/home/-nav";
import { OpenSourceSection } from "@/routes/home/-open-source";
import { StackSection } from "@/routes/home/-stack";

let starsPromise: Promise<number> | null = null;

function fetchGitHubStars(): Promise<number> {
  if (!starsPromise) {
    starsPromise = fetch("https://api.github.com/repos/mau671/claustrum")
      .then((r) => r.json() as Promise<{ stargazers_count?: number }>)
      .then((data) => data.stargazers_count ?? 0)
      .catch(() => 0);
  }
  return starsPromise;
}

export const Route = createLazyFileRoute("/_index")({
  component: HomePage,
});

function HomePage() {
  const [starCount, setStarCount] = useState<number | null>(null);

  useEffect(() => {
    void fetchGitHubStars().then(setStarCount);
  }, []);

  return (
    <div className="bg-background font-body text-foreground relative min-h-screen before:pointer-events-none before:absolute before:inset-0 before:z-0 before:bg-[linear-gradient(to_right,var(--border)_1px,transparent_1px),linear-gradient(to_bottom,var(--border)_1px,transparent_1px)] before:bg-[size:40px_40px] before:opacity-40">
      <div className="relative z-10">
        <HomeNav starCount={starCount} />

        <main id="main-content">
          <HeroSection starCount={starCount} />

          <FeaturesSection />

          <StackSection />

          <OpenSourceSection />

          <FooterCTA />

          <HomeFooter />
        </main>
      </div>
    </div>
  );
}

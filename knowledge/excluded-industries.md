# Excluded Industries — Hard Filter

These industries are permanently excluded. Any stock in these industries is an automatic fail regardless of other metrics.

| # | Industry | Reason |
|---|----------|--------|
| 1 | Pure AI | Too speculative, hard to value, outside competence |
| 2 | Airlines | Capital-destructive, razor-thin margins, commodity pricing |
| 3 | Banks | Complex balance sheets, hard to evaluate risk |
| 4 | Biotech | Binary outcomes, outside competence |
| 5 | Car Manufacturers | Cyclical, capital-intensive, low returns on capital |
| 6 | Insurance | Complex (float, reserves), requires specialized knowledge |
| 7 | Marine Freight | Volatile, commodity-driven, hard to predict |
| 8 | Precious Metal Miners | Commodity prices out of anyone's control |
| 9 | Restaurants | High failure rates, intense competition, low margins |
| 10 | Tobacco | Secular decline |
| 11 | Textiles | Low barriers, race-to-the-bottom pricing |
| 12 | Trading Firms | Opaque, unpredictable |
| 13 | Most Software | Often overvalued, hard to assess durability |
| 14 | Video Games | Hit-driven, unpredictable revenue |

## SIC/GICS Mapping Notes

When filtering via FMP API, map these to sector/industry classifications:
- Airlines → "Airlines" industry
- Banks → "Banks—Diversified", "Banks—Regional"
- Biotech → "Biotechnology"
- Car Manufacturers → "Auto Manufacturers" (NOT auto parts — auto parts like CPS are allowed)
- Insurance → "Insurance—Diversified", "Insurance—Life", "Insurance—Property & Casualty", "Insurance—Reinsurance", "Insurance—Specialty"
- Marine Freight → "Marine Shipping"
- Precious Metal Miners → "Gold", "Silver"
- Restaurants → "Restaurants"
- Tobacco → "Tobacco"
- Textiles → "Textile Manufacturing"
- Trading Firms → "Capital Markets" (trading-focused)
- Software → Use judgment — exclude pure SaaS with >15x P/S and no path to profitability
- Video Games → "Electronic Gaming & Multimedia"

## Important Exceptions
- **Auto parts** (e.g., CPS, AAP) are NOT excluded — only car manufacturers
- **Fintech/Payments** (e.g., PYPL) are NOT excluded — only traditional banks
- **Cell towers** (e.g., IHS) are NOT excluded
- **Medical devices** (e.g., TCMD) are NOT excluded — only biotech

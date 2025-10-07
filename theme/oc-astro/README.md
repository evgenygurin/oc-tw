# oc-astro OpenCart Theme

Modern e-commerce theme for OpenCart inspired by [Astro Ecommerce](https://www.creative-tim.com/product/astro-ecommerce) by Creative Tim.

## Features

- 🎨 Modern UI based on Astro Ecommerce design system
- 📱 Fully responsive Bootstrap 5 layout
- 🛍️ Product cards with hover effects
- 🎯 Category filtering and product grids
- 🛒 Shopping cart components
- ⭐ Product reviews and ratings
- 📦 Order history views
- 🎁 Incentives and promo sections

## Installation

### 1. Copy theme files to OpenCart

In your OpenCart installation, the theme should be mounted or copied to:
```
/path/to/opencart/catalog/view/theme/oc-astro/
```

If you're using the Docker Compose setup from this repo, the bind mount is already configured:
```yaml
volumes:
  - ./theme/oc-astro:/bitnami/opencart/catalog/view/theme/oc-astro
```

### 2. Download and place Bootstrap & FontAwesome assets

This theme requires Bootstrap 5 CSS/JS and FontAwesome icons. You can:

**Option A:** Use CDN links (quick setup)
- Edit `template/common/header.twig` to add CDN links for Bootstrap and FontAwesome

**Option B:** Download locally (recommended for production)
- Download [Bootstrap 5](https://getbootstrap.com/docs/5.3/getting-started/download/)
- Download [FontAwesome](https://fontawesome.com/download)
- Place files in:
  - `oc-astro/stylesheet/bootstrap.min.css`
  - `oc-astro/js/bootstrap.bundle.min.js`
  - FontAwesome CSS and webfonts

### 3. Compile Astro Ecommerce styles (optional)

If you want the full Astro Ecommerce design system styles:

```bash
# Clone the Astro Ecommerce repo
git clone https://github.com/creativetimofficial/astro-ecommerce.git

# Install dependencies and build
cd astro-ecommerce
npm install
npm run build

# Copy compiled CSS to your theme
cp dist/assets/css/astro-ecommerce.css /path/to/oc-astro/stylesheet/
```

Alternatively, you can customize `stylesheet/stylesheet.css` with your own styles inspired by Astro Ecommerce color palette and components.

### 4. Activate the theme in OpenCart Admin

1. Log in to your OpenCart admin panel
2. Go to **Extensions → Extensions → Themes**
3. Find "oc-astro" in the list
4. Click **Install** then **Edit**
5. Configure theme settings and save

## File Structure

```
theme/oc-astro/
├── template/
│   ├── common/
│   │   ├── header.twig      # Header with navigation
│   │   ├── footer.twig      # Footer with links
│   │   └── home.twig        # Homepage layout
│   ├── product/
│   │   ├── product.twig     # Product detail page
│   │   ├── category.twig    # Category/listing page
│   │   └── search.twig      # Search results
│   └── checkout/
│       └── cart.twig        # Shopping cart
├── stylesheet/
│   ├── stylesheet.css       # Theme-specific styles
│   ├── astro-ecommerce.css  # Astro Ecommerce compiled styles (optional)
│   └── bootstrap.min.css    # Bootstrap 5 (download separately)
├── js/
│   ├── common.js            # Theme JS
│   └── bootstrap.bundle.min.js  # Bootstrap JS (download separately)
└── image/
    └── (your images here)
```

## Customization

### Colors

Edit `stylesheet/stylesheet.css` to customize the color palette. The Astro Ecommerce theme uses:
- Primary: `#7c3aed` (purple)
- Background: `#0b0b0f` (dark)

### Components

The theme implements these Astro Ecommerce components as Twig templates:
- `CardProduct` → product cards in grid
- `ComplexNavbar` → header navigation
- `ComplexFooter` → multi-column footer
- `IncentiveCols` → features/benefits section
- `ProductOverviewGrid` → product detail layout
- `ShoppingCart` → cart UI

## Development

### Using with Docker Compose

If you're using the Docker Compose setup from the root of this repo:

1. Start the stack:
```bash
docker compose up -d
```

2. Theme files are bind-mounted, so edits to `./theme/oc-astro/` will reflect immediately in the container at `/bitnami/opencart/catalog/view/theme/oc-astro`

3. Access OpenCart at [http://localhost:8080](http://localhost:8080)

4. After installation, go to admin panel → Extensions → Themes and activate `oc-astro`

### Adding new templates

Follow OpenCart's Twig template structure. Common template paths:
- `template/common/` - header, footer, home
- `template/product/` - product, category, manufacturer, search
- `template/checkout/` - cart, checkout
- `template/account/` - account pages, order history

## Credits

- **Design Inspiration**: [Astro Ecommerce](https://www.creative-tim.com/product/astro-ecommerce) by [Creative Tim](https://www.creative-tim.com)
- **Framework**: [Bootstrap 5](https://getbootstrap.com/)
- **Icons**: [FontAwesome](https://fontawesome.com/)
- **E-commerce Platform**: [OpenCart](https://www.opencart.com/)

## License

This theme is provided as-is for use with OpenCart. The Astro Ecommerce design is by Creative Tim under MIT license. Please respect their original work and licensing terms.

## Support

For OpenCart theme development questions, consult the [OpenCart Documentation](https://docs.opencart.com/).

For Astro Ecommerce design questions, visit the [Creative Tim Learning Lab](https://www.creative-tim.com/learning-lab/astro/overview/astro-ecommerce).


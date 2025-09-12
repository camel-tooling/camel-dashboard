# Camel Dashboard Documentation

This directory contains the documentation website for the Camel Dashboard Operator, built with [Hugo](https://gohugo.io/) and the [Docsy](https://www.docsy.dev/) theme.

## Prerequisites

- **Hugo Extended** (v0.142.0 or later): [Install Hugo](https://gohugo.io/installation/)
- **Node.js and npm**: [Install Node.js](https://nodejs.org/)
- **Git**: For cloning repositories and Hugo modules

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/camel-tooling/camel-dashboard.git
   cd camel-dashboard/docs
   ```

2. **Install dependencies:**
   ```bash
   npm install
   hugo mod tidy
   ```

3. **Run the development server:**
   ```bash
   hugo server
   ```

4. **Open your browser:**
   Navigate to `http://localhost:1313`

## Building the Site

### Development Build
```bash
# Serve locally with live reload
hugo server

# Serve with drafts and future content
hugo server -D -F

# Serve on different port
hugo server --port 8080
```

### Production Build
```bash
# Build static site to ./public directory
hugo

# Build with minification
hugo --minify

# Build for specific environment
hugo --environment production
```

## Project Structure

```
docs/
├── content/           # All content files
│   ├── _index.md     # Homepage content
│   └── docs/         # Documentation sections
│       ├── installation/
│       ├── configuration/
│       ├── plugins/
│       └── about/
├── static/           # Static assets (images, files)
├── hugo.toml         # Hugo configuration
├── package.json      # npm dependencies
├── go.mod           # Hugo modules
└── public/          # Generated site (created by hugo build)
```

## Configuration

The site configuration is in `hugo.toml`. Key settings:

- **Theme**: Uses Docsy via Hugo modules
- **Menu**: Main navigation structure
- **Params**: Site-specific settings (GitHub links, search, etc.)

## Content Management

### Adding New Pages

1. **Create a new markdown file:**
   ```bash
   hugo new docs/new-section/page-name.md
   ```

2. **Edit the front matter:**
   ```yaml
   ---
   title: "Page Title"
   weight: 10
   description: "Page description"
   ---
   ```

### Content Organization

- Use `weight` parameter to control page order
- Create `_index.md` files for section pages
- Place images in `static/images/`

### Docsy Features

The theme provides special shortcodes:

```markdown
{{% pageinfo %}}
Important information box
{{% /pageinfo %}}

{{% alert title="Warning" %}}
Alert message
{{% /alert %}}
```

## Development Workflow

1. **Make changes** to content or configuration
2. **Test locally** with `hugo server`
3. **Check for errors** in the terminal output
4. **Build** with `hugo` to verify production build
5. **Commit changes** when satisfied

## Troubleshooting

### Common Issues

**Hugo modules not found:**
```bash
hugo mod tidy
hugo mod get github.com/google/docsy@v0.10.0
```

**PostCSS errors:**
```bash
npm install
```

**Site not updating:**
- Clear browser cache
- Restart hugo server
- Check for syntax errors in markdown

### Useful Commands

```bash
# Check Hugo version
hugo version

# Validate site configuration
hugo config

# List all pages
hugo list all

# Check module dependencies
hugo mod graph
```

## Deployment

The site generates static files that can be deployed to any web server:

```bash
# Build for production
hugo --minify

# Deploy the ./public directory to your hosting provider
```

Popular hosting options:
- **GitHub Pages**: Automatic deployment from repository
- **Netlify**: Connect to Git repository for automatic builds
- **Vercel**: Similar to Netlify with automatic deployments

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test locally with `hugo server`
5. Submit a pull request

For more information about Hugo and Docsy, see:
- [Hugo Documentation](https://gohugo.io/documentation/)
- [Docsy Documentation](https://www.docsy.dev/docs/)
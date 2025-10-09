---
name: ⚡ Performance Issue
about: Report performance problems or optimization opportunities
title: '[PERFORMANCE] '
labels: ['performance', 'needs-investigation']
assignees: ''
---

## ⚡ Performance Issue Report

### **Issue Summary**
A clear and concise description of the performance problem.

### **Performance Category**
- [ ] Page Load Speed
- [ ] Database Query Performance
- [ ] Memory Usage
- [ ] CPU Usage
- [ ] Network/API Response Time
- [ ] JavaScript Performance
- [ ] CSS/Rendering Performance
- [ ] File I/O Operations
- [ ] Cache Performance
- [ ] Mobile Performance
- [ ] Other: ___________

---

## 📊 Performance Metrics

### **Current Performance**
- **Page Load Time:** [e.g., 5.2 seconds]
- **Time to First Byte (TTFB):** [e.g., 2.1 seconds]
- **First Contentful Paint (FCP):** [e.g., 3.5 seconds]
- **Largest Contentful Paint (LCP):** [e.g., 4.8 seconds]
- **Cumulative Layout Shift (CLS):** [e.g., 0.15]
- **First Input Delay (FID):** [e.g., 250ms]

### **Expected Performance**
- **Target Load Time:** [e.g., < 2 seconds]
- **Acceptable Range:** [e.g., 1-3 seconds]
- **Industry Benchmark:** [if known]

### **Performance Tools Used**
- [ ] Google PageSpeed Insights
- [ ] GTmetrix
- [ ] WebPageTest
- [ ] Chrome DevTools
- [ ] New Relic
- [ ] Pingdom
- [ ] Custom monitoring
- [ ] Other: ___________

---

## 🔍 Affected Areas

### **Pages/Sections Affected**
- [ ] Homepage
- [ ] Product pages
- [ ] Category pages
- [ ] Search results
- [ ] Checkout process
- [ ] Admin panel
- [ ] API endpoints
- [ ] Mobile pages
- [ ] All pages
- [ ] Specific page: ___________

### **User Impact**
- [ ] All users affected
- [ ] Mobile users primarily
- [ ] Desktop users primarily
- [ ] Specific regions: ___________
- [ ] High-traffic periods only
- [ ] Specific user groups: ___________

---

## 🌍 Environment Details

### **Server Environment**
- **Hosting Provider:** [e.g., AWS, DigitalOcean, Shared hosting]
- **Server Type:** [e.g., VPS, Dedicated, Cloud]
- **CPU:** [e.g., 4 cores, 2.4GHz]
- **RAM:** [e.g., 8GB]
- **Storage:** [e.g., SSD, HDD, NVMe]
- **Operating System:** [e.g., Ubuntu 20.04]
- **Web Server:** [e.g., Apache 2.4.41, Nginx 1.18.0]
- **PHP Version:** [e.g., 8.1.2]
- **Database:** [e.g., MySQL 8.0.28, MariaDB 10.6.7]

### **OpenCart Configuration**
- **Version:** [e.g., 4.1.0.4]
- **Theme:** [e.g., Default, Custom theme]
- **Extensions:** [List performance-related extensions]
- **Caching:** [e.g., File cache, Redis, Memcached, None]
- **CDN:** [e.g., CloudFlare, AWS CloudFront, None]
- **Image Optimization:** [e.g., WebP, Compression level]

### **Database Details**
- **Database Size:** [e.g., 2.5GB]
- **Number of Products:** [e.g., 10,000]
- **Number of Categories:** [e.g., 500]
- **Number of Orders:** [e.g., 50,000]
- **Indexing Status:** [e.g., Properly indexed, Missing indexes]

---

## 📈 Performance Analysis

### **Bottleneck Identification**
- [ ] Database queries (slow/numerous)
- [ ] Large file sizes (images/CSS/JS)
- [ ] Unoptimized images
- [ ] Missing caching
- [ ] Inefficient algorithms
- [ ] Memory leaks
- [ ] Network latency
- [ ] Third-party integrations
- [ ] Unoptimized database indexes
- [ ] Other: ___________

### **Peak Usage Patterns**
- **Traffic Volume:** [e.g., 1000 concurrent users]
- **Peak Hours:** [e.g., 2-4 PM EST]
- **Seasonal Patterns:** [e.g., Holiday shopping]
- **Geographic Distribution:** [e.g., 70% US, 30% EU]

---

## 🔧 Reproduction Steps

### **Steps to Reproduce the Performance Issue:**
1. Go to [specific URL or section]
2. Perform [specific action]
3. Measure [specific metric]
4. Observe [performance problem]

### **Test Conditions:**
- **Network Speed:** [e.g., 3G, 4G, Broadband]
- **Device Type:** [e.g., Desktop, Mobile, Tablet]
- **Browser:** [e.g., Chrome 98, Firefox 97]
- **Cache State:** [e.g., Cold cache, Warm cache]
- **User State:** [e.g., Logged in, Guest]

---

## 📊 Performance Evidence

### **Screenshots/Reports**
<!-- Attach performance reports, screenshots from tools like PageSpeed Insights, GTmetrix, etc. -->

### **Profiling Data**
```
Paste profiling data, slow query logs, or performance traces here
```

### **Network Analysis**
```
Include network waterfall charts or timing data
```

### **Database Query Analysis**
```sql
-- Paste slow queries or query analysis here
EXPLAIN SELECT ...
```

---

## 💡 Suggested Optimizations

### **Immediate Improvements**
- [ ] Enable caching
- [ ] Optimize images
- [ ] Minify CSS/JavaScript
- [ ] Enable compression
- [ ] Optimize database queries
- [ ] Add missing indexes
- [ ] Other: ___________

### **Long-term Optimizations**
- [ ] Implement CDN
- [ ] Database optimization
- [ ] Code refactoring
- [ ] Infrastructure upgrade
- [ ] Caching strategy improvement
- [ ] Image optimization pipeline
- [ ] Other: ___________

### **Estimated Impact**
- **Expected Improvement:** [e.g., 50% faster load times]
- **Implementation Effort:** [e.g., Low, Medium, High]
- **Priority Level:** [e.g., Critical, High, Medium, Low]

---

## 🎯 Performance Goals

### **Target Metrics**
- **Page Load Time:** < [target] seconds
- **TTFB:** < [target] ms
- **Core Web Vitals:**
  - LCP: < 2.5s
  - FID: < 100ms
  - CLS: < 0.1

### **Business Impact**
- **Conversion Rate Impact:** [estimated effect]
- **User Experience Impact:** [description]
- **SEO Impact:** [search ranking considerations]
- **Revenue Impact:** [if quantifiable]

---

## 🔗 Related Information

### **Related Issues:**
- Related to #
- Caused by #
- Blocks #

### **External Resources:**
- Performance audit report: [URL]
- Monitoring dashboard: [URL]
- Third-party analysis: [URL]

---

## 📋 Additional Context

### **Timeline**
- **When did this start?** [e.g., After recent update, Always been slow]
- **Urgency:** [e.g., Affecting sales, User complaints, SEO impact]

### **Constraints**
- **Budget limitations:** [if any]
- **Technical constraints:** [e.g., Shared hosting, Legacy systems]
- **Timeline requirements:** [e.g., Must fix before holiday season]

### **Additional Notes**
<!-- Any other context, technical details, or information about the performance issue -->

---

## ✅ Checklist

Before submitting this performance report:

- [ ] I have measured the performance issue objectively
- [ ] I have provided specific metrics and evidence
- [ ] I have identified the affected areas and user impact
- [ ] I have included environment and configuration details
- [ ] I have suggested potential optimizations
- [ ] I have checked for related existing issues

---

**Thank you for helping improve OpenCart's performance! Better performance benefits all users and improves the overall e-commerce experience.**
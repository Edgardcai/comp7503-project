# Smart City Data Analysis System

A comprehensive smart city data collection, analysis, and visualization platform based on Hong Kong Open Data.

**Course**: COMP7503 Multimedia Technologies
**Submission Deadline**: November 29, 2025, 23:55
**Project Type**: Smart City Programming Assignment

---

## Table of Contents

- [Project Overview](#project-overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Usage Guide](#usage-guide)
- [Data Visualization](#data-visualization)
- [Database Management](#database-management)
- [Troubleshooting](#troubleshooting)
- [Performance Optimization](#performance-optimization)
- [Project Submission](#project-submission)

---

## Project Overview

This project implements a smart city data platform that:

- **Collects** real-time data from Hong Kong Open Data Portal (data.gov.hk)
- **Processes** and analyzes multiple data sources (air quality, weather, traffic)
- **Stores** historical data in MongoDB for time-series analysis
- **Visualizes** data through interactive dashboards
- **Correlates** data across different domains to extract insights

### Use Cases Implemented

1. **Air Quality Monitoring**: Real-time AQI tracking across Hong Kong districts
2. **Weather Data Analysis**: Temperature and humidity trends by location
3. **Traffic Flow Analysis**: Traffic density, speed, and volume monitoring

---

## Features

✅ **Real-time Data Collection**
- Air quality data: Every 1.5 minutes
- Weather data: Every 3 minutes
- Traffic data: Every 1 minute

✅ **Advanced Visualization**
- Interactive dashboards with multiple chart types
- Real-time updates
- Responsive design

✅ **Data Analysis**
- Correlation analysis
- Trend detection
- Anomaly identification

✅ **Containerized Deployment**
- Docker-based architecture
- Isolated environments
- Easy scaling

---

## Tech Stack

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Data Collection** | Node-RED | Visual flow-based programming |
| **Database** | MongoDB | Time-series data storage |
| **Visualization** | Node-RED Dashboard | Real-time charts and gauges |
| **Containerization** | Docker | Environment isolation |
| **Data Source** | data.gov.hk APIs | Open government data |

---

## Quick Start

### Prerequisites

Ensure you have installed:

- **Docker**: 20.10+ ([Download](https://www.docker.com/products/docker-desktop))
- **8GB+ RAM** recommended
- **10GB+ free disk space**

Verify installation:

```bash
docker --version
docker ps
```

### Installation Steps

#### Step 1: Create Docker Network

```bash
docker network create my-app-network
```

#### Step 2: Start MongoDB Container

```bash
docker run -d --name mymongo --network my-app-network \
-p 27017:27017 \
-v /Users/zijiancai/Desktop/hkucsfiles/comp7503/hw/mongo:/data/db \
-e MONGO_INITDB_ROOT_USERNAME=admin \
-e MONGO_INITDB_ROOT_PASSWORD=1234 \
mongo:latest --auth
```

**Note**: Update the volume path to match your local directory.

#### Step 3: Start Node-RED Container

```bash
docker run -d --name nodered --network my-app-network \
-p 1880:1880 \
-v /Users/zijiancai/Desktop/hkucsfiles/comp7503/hw/nodered:/data \
nodered/node-red:latest
```

#### Step 4: Install MongoDB Nodes

```bash
# Install required Node-RED packages
docker exec nodered npm install node-red-contrib-mongodb3
docker restart nodered
```

Wait 10 seconds for Node-RED to restart.

#### Step 5: Access Node-RED

Open your browser and navigate to: **http://localhost:1880**

#### Step 6: Import Flow

1. Click the menu (≡) → **Import**
2. Click **select a file to import**
3. Choose `SmartCity.Flow.json`
4. Click **Import**

#### Step 7: Deploy

Click the **Deploy** button (top right, red color).

#### Step 8: Access Dashboard

Open a new tab: **http://localhost:1880/ui**

You should see the Smart City Dashboard with:
- Air Quality Monitoring
- Weather Data
- Traffic Analysis

---

## Project Structure

```
hw/
├── SmartCity.Flow.json          # Core Node-RED flow definition
├── HKO.Flow.json                # Weather data flow (optional)
├── README.md                    # This file
├── Project_Report.md            # Detailed project report
├── Dockerfile                   # Custom Node-RED image (optional)
├── .gitignore                   # Git ignore rules
├── mongo/                       # MongoDB data directory
│   └── (auto-generated files)
└── nodered/                     # Node-RED data directory
    ├── flows.json               # Active flows
    ├── flows_cred.json          # Credentials (encrypted)
    └── package.json             # Installed packages
```

### File Descriptions

| File | Size | Description |
|------|------|-------------|
| `SmartCity.Flow.json` | ~21 KB | Main flow with air quality, weather, and traffic data collection |
| `README.md` | ~15 KB | Quick start guide and usage instructions |
| `Project_Report.md` | ~40 KB | Comprehensive project documentation |
| `mongo/` | Dynamic | MongoDB data files (auto-generated) |
| `nodered/` | Dynamic | Node-RED configuration and flows |

---

## Usage Guide

### Triggering Data Collection

**Manual Trigger**:
- In Node-RED editor, click the small button on the left side of any inject node

**Automatic Trigger**:
- Air quality: Every 1.5 minutes
- Weather: Every 3 minutes
- Traffic: Every 1 minute

### Viewing Live Data

1. **Dashboard**: http://localhost:1880/ui
   - Real-time charts update automatically
   - No refresh needed

2. **Debug Panel** (in Node-RED):
   - Click the bug icon (🐛) on the right sidebar
   - View raw data flowing through the system

### Customizing Data Collection

**Change Collection Frequency**:

1. Double-click an inject node
2. Modify the **Repeat** field (in seconds)
   - Current: 90s (1.5min), 180s (3min), 60s (1min)
3. Click **Done**
4. Click **Deploy**

**Add New Data Sources**:

1. Drag an `http request` node from the palette
2. Configure the API endpoint
3. Add a `function` node to parse data
4. Connect to a `mongodb3 in` node for storage
5. Add dashboard nodes for visualization

---

## Data Visualization

### Air Quality Monitoring

1. **City Average AQI** (Gauge)
   - Range: 0-100
   - Color-coded: Green (0-50), Yellow (50-75), Red (75-100)

2. **AQI by District** (Bar Chart)
   - Shows: Current AQI for each district
   - Districts: Central & Western, Eastern, Kwun Tong, Sham Shui Po, Kwai Tsing

### Weather Data

1. **Temperature by Location** (Line Chart)
   - Range: 10-35°C
   - Multiple locations displayed simultaneously
   - 24-hour data retention

### Traffic Analysis

1. **Traffic Density Status** (Pie Chart)
   - Categories: Smooth, Slow, Congested
   - Color-coded by severity

2. **Average Traffic Speed** (Bar Chart)
   - Range: 0-80 km/h
   - By location

3. **Vehicle Count by Location** (Bar Chart)
   - Range: 0-200 vehicles
   - Shows current traffic volume

---

## Database Management

### Access MongoDB Shell

```bash
docker exec -it mymongo mongosh -u admin -p 1234 --authenticationDatabase admin
```

### Common Commands

```javascript
// Switch to smartcity database
use smartcity

// View all collections
show collections

// Count documents
db.air_quality.countDocuments()
db.weather_data.countDocuments()
db.traffic_flow.countDocuments()

// Query latest records
db.air_quality.find().sort({timestamp: -1}).limit(5)

// Query by station
db.air_quality.find({station: "Central & Western"})

// Aggregate data
db.air_quality.aggregate([
  {$match: {timestamp: {$gte: new Date(Date.now() - 3600000)}}},
  {$group: {_id: "$station", avgAQI: {$avg: "$aqi"}}}
])
```

### Data Backup

```bash
# Create backup
docker exec mymongo mongodump -u admin -p 1234 \
--authenticationDatabase admin --db=smartcity --out=/data/backup

# Copy to local
docker cp mymongo:/data/backup ./backup

# Compress
zip -r mongodb_backup.zip backup/
```

### Data Restore

```bash
# Copy backup to container
docker cp ./backup mymongo:/data/backup

# Restore data
docker exec mymongo mongorestore -u admin -p 1234 \
--authenticationDatabase admin --db=smartcity /data/backup/smartcity
```

---

## Troubleshooting

### Issue 1: Cannot Access Node-RED

**Symptoms**: Browser shows "Unable to connect"

**Solutions**:
```bash
# Check container status
docker ps | grep nodered

# View logs
docker logs nodered

# Restart container
docker restart nodered
```

### Issue 2: Dashboard Shows No Data

**Causes**:
- Database empty (just started)
- MongoDB connection failed
- Incorrect node configuration

**Solutions**:
```bash
# Check if data exists
docker exec -it mymongo mongosh -u admin -p 1234 --eval \
"use smartcity; db.air_quality.countDocuments()"

# Manually trigger data collection
# In Node-RED, click inject nodes

# Check debug panel for errors
```

### Issue 3: MongoDB Authentication Error

**Error**: `MongoError: Authentication failed`

**Solution**:
1. Double-click any MongoDB node in Node-RED
2. Click the pencil icon next to "Server"
3. Verify credentials:
   - Host: `mymongo`
   - Username: `admin`
   - Password: `1234`
   - Auth Source: `admin`

### Issue 4: Port Already in Use

**Error**: `Bind for 0.0.0.0:1880 failed: port is already allocated`

**Solution**:

Option 1 - Stop conflicting service:
```bash
# macOS/Linux
lsof -i :1880
kill -9 <PID>
```

Option 2 - Use different port:
```bash
docker stop nodered && docker rm nodered
docker run -d --name nodered --network my-app-network \
-p 1881:1880 \
-v /Users/zijiancai/Desktop/hkucsfiles/comp7503/hw/nodered:/data \
nodered/node-red:latest
```

Then access: http://localhost:1881

### Issue 5: Container Keeps Restarting

```bash
# Check logs for errors
docker logs nodered --tail 50

# Check MongoDB connection
docker exec nodered ping mymongo

# Verify network
docker network inspect my-app-network
```

---

## Performance Optimization

### 1. Reduce Collection Frequency

If system is slow, increase intervals:
- Air quality: 90s → 300s (5 min)
- Weather: 180s → 600s (10 min)
- Traffic: 60s → 300s (5 min)

### 2. Limit Chart Data Points

In chart nodes, set `removeOlder`:
```javascript
{
    "removeOlder": 24,      // Keep only 24 hours
    "removeOlderUnit": "3600"  // In seconds
}
```

### 3. Create Database Indexes

```javascript
// In MongoDB
db.air_quality.createIndex({timestamp: -1})
db.air_quality.createIndex({station: 1, timestamp: -1})
db.traffic_flow.createIndex({timestamp: -1})
```

### 4. Clean Old Data

```javascript
// Delete data older than 30 days
db.air_quality.deleteMany({
    timestamp: {$lt: new Date(Date.now() - 30*24*3600000)}
})
```

---

## Stopping and Cleanup

### Stop Containers (Keep Data)

```bash
docker stop nodered mymongo
```

### Restart Containers

```bash
docker start mymongo nodered
```

### Remove Containers (Keep Data)

```bash
docker stop nodered mymongo
docker rm nodered mymongo
```

Data is preserved in `mongo/` and `nodered/` directories.

### Complete Cleanup (Delete Everything)

```bash
# WARNING: This deletes all data!
docker stop nodered mymongo
docker rm nodered mymongo
rm -rf mongo/* nodered/*
docker network rm my-app-network
```

---

## Project Submission

### Required Files

1. ✅ `SmartCity.Flow.json` - Core flow definition
2. ✅ `README.md` - This documentation
3. ✅ `Project_Report.pdf` - Converted from Project_Report.md
4. ✅ `Dockerfile` OR Docker Hub link

### Submission Package

Create a ZIP file:

```bash
# Include only source files, not data
zip -r StudentID_Name_COMP7503.zip \
  SmartCity.Flow.json \
  README.md \
  Project_Report.pdf \
  Dockerfile

# Example: 3035123456_JohnDoe_COMP7503.zip
```

**Do NOT include**:
- `mongo/` directory
- `nodered/` directory
- `node_modules/`
- `.DS_Store`, `.git/`

### Converting Report to PDF

**Method 1: Using Pandoc**
```bash
pandoc Project_Report.md -o Project_Report.pdf \
--pdf-engine=xelatex --toc
```

**Method 2: Using Typora**
1. Open `Project_Report.md` in Typora
2. File → Export → PDF

**Method 3: Online**
- Visit: https://www.markdowntopdf.com/

### Submission Checklist

- [ ] All containers start successfully
- [ ] Flow imports without errors
- [ ] Dashboard displays data correctly
- [ ] MongoDB connections work
- [ ] README.md is complete
- [ ] Project report converted to PDF
- [ ] File size < 10MB (excluding data)
- [ ] Proper naming convention used

---

## Additional Resources

### Official Documentation

- [Node-RED](https://nodered.org/docs/)
- [MongoDB](https://www.mongodb.com/docs/)
- [Docker](https://docs.docker.com/)
- [data.gov.hk](https://data.gov.hk/)

### Node-RED Packages Used

- `node-red-dashboard` - Dashboard UI components
- `node-red-contrib-mongodb3` - MongoDB integration

### Data Sources

- **Air Quality**: HK EPD Air Quality Health Index
- **Weather**: HK Observatory Weather API
- **Traffic**: Simulated (for demonstration)

---

## Support

### Getting Help

1. Check this README's troubleshooting section
2. Review Node-RED debug panel
3. Check Docker container logs
4. Verify network connectivity

### Contact Information

**Course**: COMP7503 Multimedia Technologies
**Institution**: The University of Hong Kong

---

## License

This project is for educational purposes as part of COMP7503 coursework.

---

## Acknowledgments

- Hong Kong Government Data Portal for open data APIs
- Node-RED community for excellent tools
- MongoDB for robust time-series data storage

---

**Last Updated**: November 2025
**Version**: 2.0 (English Edition)

**Good luck with your project! 🎉**

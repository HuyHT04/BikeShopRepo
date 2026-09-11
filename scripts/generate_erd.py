from pathlib import Path
import xml.etree.ElementTree as ET


TABLES = {
    "Categories": ["PK Id", "Name", "UQ Slug", "Description", "IsActive"],
    "Brands": ["PK Id", "Name", "UQ Slug", "IsActive"],
    "Products": ["PK Id", "FK CategoryId", "FK BrandId", "Name", "UQ Slug", "Description", "IsActive", "CreatedAt"],
    "ProductVariants": ["PK Id", "FK ProductId", "UQ Sku", "Color", "Size", "Price", "StockQuantity", "RowVersion"],
    "ProductImages": ["PK Id", "FK ProductId", "ImageUrl", "AltText", "SortOrder"],
    "InventoryTransactions": ["PK Id", "FK ProductVariantId", "QuantityChange", "Reason", "ReferenceCode", "CreatedAt"],
    "Addresses": ["PK Id", "FK UserId", "RecipientName", "PhoneNumber", "AddressLine", "Ward", "District", "Province", "IsDefault"],
    "Carts": ["PK Id", "UQ FK UserId", "UpdatedAt"],
    "CartItems": ["PK Id", "FK CartId", "FK ProductVariantId", "Quantity"],
    "Orders": ["PK Id", "UQ OrderCode", "FK UserId", "Status", "RecipientName", "PhoneNumber", "ShippingAddress", "Subtotal", "ShippingFee", "TotalAmount", "CreatedAt"],
    "OrderItems": ["PK Id", "FK OrderId", "FK ProductVariantId", "ProductName snapshot", "Sku snapshot", "UnitPrice", "Quantity", "LineTotal"],
    "OrderStatusHistories": ["PK Id", "FK OrderId", "OldStatus", "NewStatus", "Note", "FK ChangedByUserId", "ChangedAt"],
}

POSITIONS = {
    "Categories": (40, 100), "Brands": (40, 330), "Products": (350, 190),
    "ProductVariants": (670, 100), "ProductImages": (670, 390), "InventoryTransactions": (1000, 50),
    "Carts": (40, 650), "CartItems": (350, 650), "Addresses": (40, 900),
    "Orders": (670, 680), "OrderItems": (1000, 650), "OrderStatusHistories": (1000, 940),
}

RELATIONS = [
    ("Categories", "Products", "1:N"), ("Brands", "Products", "1:N"),
    ("Products", "ProductVariants", "1:N"), ("Products", "ProductImages", "1:N"),
    ("ProductVariants", "InventoryTransactions", "1:N"),
    ("Carts", "CartItems", "1:N"), ("ProductVariants", "CartItems", "1:N"),
    ("Orders", "OrderItems", "1:N"), ("ProductVariants", "OrderItems", "1:N"),
    ("Orders", "OrderStatusHistories", "1:N"),
]


def main() -> None:
    mxfile = ET.Element("mxfile", host="app.diagrams.net", modified="2026-09-11T00:00:00.000Z", agent="Codex", version="26.0.0")
    diagram = ET.SubElement(mxfile, "diagram", id="bikeshop-erd", name="BikeShop ERD")
    model = ET.SubElement(diagram, "mxGraphModel", dx="1422", dy="1234", grid="1", gridSize="10", page="1", pageScale="1", pageWidth="1600", pageHeight="1200", background="#FFFFFF")
    root = ET.SubElement(model, "root")
    ET.SubElement(root, "mxCell", id="0")
    ET.SubElement(root, "mxCell", id="1", parent="0")

    title = ET.SubElement(root, "mxCell", id="title", value="BikeShop SWP391 Database ERD", style="text;html=1;align=center;verticalAlign=middle;fontSize=24;fontStyle=1;", vertex="1", parent="1")
    ET.SubElement(title, "mxGeometry", x="420", y="20", width="600", height="40", **{"as": "geometry"})

    identity = ET.SubElement(root, "mxCell", id="identity", value="ASP.NET Core Identity\nAspNetUsers and role tables\nUserId is referenced by Address, Cart, Order and audit records", style="rounded=1;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;fontSize=12;", vertex="1", parent="1")
    ET.SubElement(identity, "mxGeometry", x="350", y="930", width="300", height="105", **{"as": "geometry"})

    ids = {}
    for index, (name, columns) in enumerate(TABLES.items(), start=10):
        ids[name] = str(index)
        x, y = POSITIONS[name]
        height = 42 + len(columns) * 18
        value = f"<b>{name}</b><br>" + "<br>".join(columns)
        color = "#dae8fc" if name in {"Categories", "Brands", "Products", "ProductVariants", "ProductImages", "InventoryTransactions"} else "#d5e8d4"
        cell = ET.SubElement(root, "mxCell", id=str(index), value=value, style=f"rounded=0;whiteSpace=wrap;html=1;align=left;verticalAlign=top;spacing=8;fillColor={color};strokeColor=#6c8ebf;fontSize=11;", vertex="1", parent="1")
        ET.SubElement(cell, "mxGeometry", x=str(x), y=str(y), width="250", height=str(height), **{"as": "geometry"})

    for edge_index, (source, target, label) in enumerate(RELATIONS, start=100):
        edge = ET.SubElement(root, "mxCell", id=str(edge_index), value=label, style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;endArrow=ERmany;startArrow=ERone;", edge="1", parent="1", source=ids[source], target=ids[target])
        ET.SubElement(edge, "mxGeometry", relative="1", **{"as": "geometry"})

    for edge_index, target in enumerate(["Addresses", "Carts", "Orders", "OrderStatusHistories"], start=200):
        edge = ET.SubElement(root, "mxCell", id=str(edge_index), value="UserId", style="edgeStyle=orthogonalEdgeStyle;dashed=1;html=1;endArrow=open;", edge="1", parent="1", source="identity", target=ids[target])
        ET.SubElement(edge, "mxGeometry", relative="1", **{"as": "geometry"})

    output = Path(__file__).resolve().parents[1] / "database" / "DATABASE_ERD.drawio"
    output.parent.mkdir(parents=True, exist_ok=True)
    ET.ElementTree(mxfile).write(output, encoding="utf-8", xml_declaration=True)
    print(output)


if __name__ == "__main__":
    main()
